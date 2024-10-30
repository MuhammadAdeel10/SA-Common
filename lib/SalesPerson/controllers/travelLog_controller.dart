import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sa_common/Controller/BaseController.dart';
import 'package:location/location.dart' as l;
import 'package:permission_handler/permission_handler.dart';
import 'package:sa_common/SalesPerson/database/travelLog_database.dart';
import 'package:sa_common/SalesPerson/model/TravelLogModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/pref_utils.dart';

class TravelLogController extends BaseController {
  bool gpsEnabled = false;
  bool permissionGranted = false;
  l.Location location = l.Location();
  late StreamSubscription subscription;
  bool trackingEnabled = false;
  List<l.LocationData> locations = [];
  DateTime? dateTime = null;

  @override
  Future<void> onInit() async {
    super.onInit();
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
    return await Permission.location.serviceStatus.isEnabled;
  }

  addLocation(l.LocationData data) {
    locations.insert(0, data);
  }

  Future startTracking() async {
    if (!(await isGpsEnabled())) {
      requestEnableGps();
      return;
    }

    if (!(await isPermissionGranted())) {
      return;
    }
    await location.changeSettings(distanceFilter: 25);
    subscription = location.onLocationChanged.listen((event) async {
      await CreateTravelLog(event);
    });
    CheckInOut(isCheckIn: true);
    trackingEnabled = true;
  }

  Future<void> stopTracking() async {
    subscription = location.onLocationChanged.listen((event) async {
      await CreateTravelLog(event);
    });
    CheckInOut(isCheckIn: false);
    await SyncToServerTravelLog();
    trackingEnabled = false;
    subscription.cancel();
    clearLocation();
  }

  clearLocation() {
    locations.clear();
  }

  void requestEnableGps() async {
    if ((await isGpsEnabled())) {
      log("Already open");
      gpsEnabled = true;
    } else {
      bool isGpsActive = await location.requestService();
      if (!isGpsActive) {
        gpsEnabled = false;
        log("User did not turn on GPS");
      } else {
        log("gave permission to the user and opened it");
        gpsEnabled = true;
      }
    }
  }

  Future<void> requestLocationPermission(String title, String description) async {
    PermissionStatus? permissionStatus = await Permission.locationAlways.request();
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
                        child: Text(
                          'No',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
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
                        child: Text(
                          'Yes',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
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
      //await checkStatus();
    }
  }

  Future<void> CreateTravelLog(l.LocationData event) async {
    try {
      TravelLogModel travelLog = TravelLogModel(speed: event.speed ?? 0.0, latitude: event.latitude ?? 0.0, longitude: event.longitude ?? 0.0, locationDateTime: DateTime.now(), heading: event.heading ?? 0.0, altitude: event.altitude ?? 0.0, altitudeAccuracy: event.speedAccuracy ?? 0.0, applicationUserId: Helper.user.userId, branchId: Helper.user.branchId, serverDateTime: DateTime.now().toUtc());
      await TravelLogDatabase.dao.insert(travelLog);

      if (await Helper.hasNetwork(ApiEndPoint.baseUrl)) {
        await SyncToServerTravelLog();
      }
    } catch (ex) {
      log("Exception Background Create Travel $ex");
    }
  }

  Future<void> SyncToServerTravelLog() async {
    var logs = await TravelLogDatabase.dao.SelectList("isSync = 0");
    if (logs != null && logs.isNotEmpty) {
      logs.forEach((element) {
        element.id = 0;
      });
      var response = await this.baseClient.post(ApiEndPoint.baseUrl, "${Helper.user.companyId}/${Helper.user.branchId}/TravelLogs", logs);
      if (response != null && response.statusCode == 200) {
        await TravelLogDatabase.bulkUpdate();
      }
    }
  }

  void CheckInOut({required bool isCheckIn}) {
    var pref = PrefUtils();
    var slug = pref.GetPreferencesString(LocalStorageKey.companySlug);
    var dateTime = DateTime.now();
    pref.SetPreferencesBool("$slug ${LocalStorageKey.isCheckIn}", isCheckIn);
    pref.SetPreferencesString("$slug ${LocalStorageKey.checkInDate}", dateTime.toIso8601String());
  }

  Future<void> BackgroundTracking() async {
    var pref = PrefUtils();
    var slug = pref.GetPreferencesString(LocalStorageKey.companySlug);
    var isCheckIn = pref.GetPreferencesBool("$slug ${LocalStorageKey.isCheckIn}");

    if (isCheckIn) {
      var locationDate = await location.getLocation();
      await CreateTravelLog(locationDate);
    }
  }
}
