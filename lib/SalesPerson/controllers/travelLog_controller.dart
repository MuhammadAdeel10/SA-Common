import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sa_common/Controller/BaseController.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sa_common/SalesPerson/database/travelLog_database.dart';
import 'package:sa_common/SalesPerson/model/TravelLogModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/pref_utils.dart';
import 'package:synchronized/synchronized.dart';
import 'package:geolocator/geolocator.dart';

class TravelLogController extends BaseController {
  bool gpsEnabled = false;
  bool permissionGranted = false;
  late StreamSubscription<Position> subscription;
  bool trackingEnabled = false;
  List<Position> locations = [];
  DateTime? dateTime;
  var lock = Lock();
  Position? _previousLocation;
  final double accuracyThreshold = 10.0;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  double _calculateDistance(Position start, Position end) {
    const double earthRadius = 6371000; // meters
    double dLat = _toRadians(end.latitude - start.latitude);
    double dLon = _toRadians(end.longitude - start.longitude);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) + math.cos(_toRadians(start.latitude)) * math.cos(_toRadians(end.latitude)) * math.sin(dLon / 2) * math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }

  checkStatus() async {
    bool _permissionGranted = await isPermissionGranted();
    bool _gpsEnabled = await isGpsEnabled();
    permissionGranted = _permissionGranted;
    gpsEnabled = _gpsEnabled;
  }

  Future<bool> isPermissionGranted() async {
    return await Permission.locationAlways.isGranted;
  }

  Future<bool> isGpsEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  addLocation(Position data) {
    locations.insert(0, data);
  }

  Future<void> startTracking() async {
    var pref = PrefUtils();
    var slug = pref.GetPreferencesString(LocalStorageKey.companySlug);
    var isCheckIn = pref.GetPreferencesBool("$slug ${LocalStorageKey.isCheckIn}");

    if (!(await isGpsEnabled())) {
      requestEnableGps();
      return;
    }

    if (!(await isPermissionGranted())) {
      return;
    }

    if (isCheckIn) {
      subscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(distanceFilter: 10),
      ).listen((Position position) async {
        if (position.speed > 0.5) {
          if (_previousLocation == null || _calculateDistance(_previousLocation!, position) > 10) {
            _previousLocation = position;
            await CreateTravelLog(position);
          }
        }
      });
      trackingEnabled = true;
    }
  }

  Future<void> stopTracking() async {
    CheckInOut(isCheckIn: false);
    await SyncToServerTravelLog();
    await Geolocator.getPositionStream().drain();
    trackingEnabled = false;
    await subscription.cancel();
    _previousLocation = null;
    clearLocation();
  }

  clearLocation() {
    locations.clear();
  }

  void requestEnableGps() async {
    if (await isGpsEnabled()) {
      log("Already open");
      gpsEnabled = true;
    } else {
      bool isGpsActive = await Geolocator.openLocationSettings();
      if (!isGpsActive) {
        gpsEnabled = false;
        log("User did not turn on GPS");
      } else {
        log("GPS enabled by user");
        gpsEnabled = true;
      }
    }
  }

  Future<void> requestLocationPermission(String title, String description) async {
    PermissionStatus permissionStatus = await Permission.locationAlways.request();
    if (permissionStatus == PermissionStatus.permanentlyDenied || permissionStatus == PermissionStatus.denied) {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 24),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('No', style: TextStyle(color: Colors.white)),
                        style: TextButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ),
                    SizedBox(width: 16),
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: TextButton(
                        onPressed: () async {
                          await openAppSettings();
                          Get.back();
                        },
                        child: Text('Yes', style: TextStyle(color: Colors.white)),
                        style: TextButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } else if (permissionStatus == PermissionStatus.granted) {
      permissionGranted = true;
    } else {
      permissionGranted = false;
    }
  }

  Future<void> CreateTravelLog(Position event, {bool isIdle = false}) async {
    try {
      TravelLogModel travelLog = TravelLogModel(
        speed: event.speed,
        latitude: event.latitude,
        longitude: event.longitude,
        locationDateTime: DateTime.now(),
        heading: event.heading,
        altitude: event.altitude,
        altitudeAccuracy: event.accuracy,
        applicationUserId: Helper.user.userId,
        branchId: Helper.user.branchId,
        serverDateTime: DateTime.now().toUtc(),
        isIdle: isIdle,
      );
      await TravelLogDatabase.dao.insert(travelLog);

      if (await Helper.hasNetwork(ApiEndPoint.baseUrl)) {
        await SyncToServerTravelLog();
      }
    } catch (ex) {
      log("Exception Background Create Travel $ex");
    }
  }

  Future<void> SyncToServerTravelLog() async {
    await lock.synchronized(
      () async {
        var logs = await TravelLogDatabase.dao.SelectList("isSync = 0 and branchId = ${Helper.user.branchId} order by locationDateTime");
        if (logs != null && logs.isNotEmpty) {
          logs.forEach((element) {
            element.id = 0;
          });
          var response = await this.baseClient.post(ApiEndPoint.baseUrl, "${Helper.user.companyId}/${Helper.user.branchId}/TravelLogs", logs);
          if (response != null && response.statusCode == 200) {
            await TravelLogDatabase.bulkUpdate();
          }
        }
      },
    );
  }

  void CheckInOut({required bool isCheckIn}) {
    var pref = PrefUtils();
    var slug = pref.GetPreferencesString(LocalStorageKey.companySlug);
    var dateTime = DateTime.now();
    pref.SetPreferencesBool("$slug ${LocalStorageKey.isCheckIn}", isCheckIn);
    pref.SetPreferencesString("$slug ${LocalStorageKey.checkInDate}", dateTime.toIso8601String());
  }

  Future<void> GetLastLocation() async {
    var pref = PrefUtils();
    var slug = pref.GetPreferencesString(LocalStorageKey.companySlug);
    var isCheckIn = pref.GetPreferencesBool("$slug ${LocalStorageKey.isCheckIn}");
    if (isCheckIn) {
      var logs = await TravelLogDatabase.dao.SelectSingle("branchId = ${Helper.user.branchId} order by locationDateTime desc limit 1");
      if (logs != null && logs.locationDateTime != null) {
        final DateTime currentTime = DateTime.now();
        final DateTime timeLimit = currentTime.subtract(Duration(minutes: 4));
        if (logs.locationDateTime!.isBefore(timeLimit)) {
          await SetCurrentLocation(isIdle: true);
        }
      }
    }
  }

  Future<void> SetCurrentLocation({bool isIdle = false}) async {
    Position position = await Geolocator.getCurrentPosition();
    await CreateTravelLog(position, isIdle: isIdle);
  }
}
