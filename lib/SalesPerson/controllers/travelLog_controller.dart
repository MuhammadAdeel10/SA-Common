import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sa_common/Controller/BaseController.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sa_common/SalesPerson/database/travelLog_database.dart';
import 'package:sa_common/SalesPerson/database/trip_database.dart';
import 'package:sa_common/SalesPerson/model/TravelLogModel.dart';
import 'package:sa_common/SalesPerson/model/trip_model.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/Enums.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sa_common/utils/pref_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class TravelLogController extends BaseController {
  bool gpsEnabled = false;
  bool permissionGranted = false;
  late StreamSubscription<Position>? subscription;
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
    var branchId = Helper.user.branchId;
    var isCheckIn = pref.GetPreferencesBool("$slug $branchId ${LocalStorageKey.isCheckIn}");

    if (!(await isGpsEnabled())) {
      requestEnableGps();
      return;
    }

    if (!(await isPermissionGranted())) {
      return;
    }

    if (isCheckIn) {
      subscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(distanceFilter: 15),
      ).listen((Position position) async {
        if (position.speed > 0.5) {
          if (_previousLocation == null || _calculateDistance(_previousLocation!, position) > 10) {
            _previousLocation = position;
            var lastLocation = await TravelLogDatabase.dao.SelectSingle("branchId = ${Helper.user.branchId} order by id desc limit 1");
            var trip = await TripDatabase.dao.SelectSingle("branchId = ${Helper.user.branchId} order by id desc limit 1");
            if (lastLocation?.isIdle == true) {
              trip?.id = await startTrip(travelStatus: TravelStatus.Moving);
            }
            await CreateTravelLog(position, tripId: trip?.id);
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
    await subscription?.cancel();
    subscription = null;
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
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
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

  Future<int> startTrip({required TravelStatus travelStatus}) async {
    try {
      TripModel trip = TripModel(
        applicationUserId: Helper.user.userId,
        branchId: Helper.user.branchId,
        startDate: DateTime.now(),
        isNew: true,
        travelStatus: travelStatus,
      );
      if (await Helper.hasNetwork(ApiEndPoint.baseUrl)) {
        await postTrip();
      }
      int id = await TripDatabase.dao.insert(trip);
      return id;
    } catch (ex) {
      log("Exception Background Start Trip $ex");
      throw ex;
    }
  }

  Future<void> postTrip() async {
    var trips = await TripDatabase.dao.SelectList("isNew = 1 and branchId = ${Helper.user.branchId}");
    if (trips != null && trips.isNotEmpty) {
      var payload = trips.map((trip) {
        trip.tripId = trip.id;
        trip.id = 0;
        return trip.toMap();
      }).toList();

      var response = await this.baseClient.post(
            ApiEndPoint.baseUrl,
            "${Helper.user.companyId}/${Helper.user.branchId}/Trips/Bulk",
            payload,
          );

      if (response != null && response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        if (responseJson["success"] != null && responseJson["success"].isNotEmpty) {
          var responseList = (responseJson["success"] as List).map((item) => TripModel.fromMap(item, slug: Helper.user.companyId)).toList();
          for (var model in responseList) {
            var travelLogs = await TravelLogDatabase.dao.SelectList("tripId = ${model.tripId}");
            if (travelLogs != null) {
              await TravelLogDatabase.BulkUpdateTrip(model.id, model.tripId, model.companySlug);
            }
          }
          final db = await DatabaseHelper.instance.database;

          try {
            await db.transaction((txn) async {
              Batch batch = txn.batch();
              for (var model in responseList) {
                batch.delete(
                  Tables.Trips,
                  where: "id = ?",
                  whereArgs: [model.tripId],
                );

                model.isNew = false;
                batch.insert(Tables.Trips, model.toMap());
              }
              await batch.commit();
            });
          } catch (e) {
            print("Transaction failed: $e");
            rethrow;
          }
        }
      }
    }
  }

  Future<void> updateTrip() async {
    var trips = await TripDatabase.dao.SelectList("isEdit = 1 and branchId = ${Helper.user.branchId}");
    if (trips != null && trips.isNotEmpty) {
      var payload = trips.map((trip) => trip.toMap()).toList();
      var response = await this.baseClient.put(
            ApiEndPoint.baseUrl,
            "${Helper.user.companyId}/${Helper.user.branchId}/Trips/Bulk",
            payload,
          );
      if (response != null && response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        if (responseJson["errors"] != null || responseJson["errors"].isNotEmpty) {
          var errorIds = (responseJson["errors"] as List).map((error) => int.tryParse(error["id"] ?? "")).where((id) => id != null).toSet();
          var tripsToDelete = trips.where((trip) => !errorIds.contains(trip.id)).toList();
          if (tripsToDelete.isNotEmpty) {
            final db = await DatabaseHelper.instance.database;
            try {
              await db.transaction((txn) async {
                Batch batch = txn.batch();
                for (var trip in tripsToDelete) {
                  batch.delete(
                    Tables.Trips,
                    where: "id = ?",
                    whereArgs: [trip.id],
                  );
                }
                await batch.commit();
              });
            } catch (e) {
              rethrow;
            }
          }
        }
      }
    }
  }

  Future endTrip() async {
    try {
      var trip = await TripDatabase.dao.SelectSingle("branchId = ${Helper.user.branchId} order by id desc limit 1");
      if (trip != null) {
        trip.isEdit = true;
        trip.endDate = DateTime.now();
        await TripDatabase.dao.update(trip);
        if (await Helper.hasNetwork(ApiEndPoint.baseUrl)) {
          await postTrip();
          await updateTrip();
        }
      }
    } catch (ex) {
      log("Exception Background End Trip $ex");
    }
  }

  Future<void> CreateTravelLog(Position event, {bool isIdle = false, int? tripId}) async {
    try {
      TravelLogModel travelLog = TravelLogModel(speed: event.speed, latitude: event.latitude, longitude: event.longitude, locationDateTime: DateTime.now(), heading: event.heading, altitude: event.altitude, altitudeAccuracy: event.accuracy, applicationUserId: Helper.user.userId, branchId: Helper.user.branchId, serverDateTime: DateTime.now().toUtc(), isIdle: isIdle, tripId: tripId);
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
    var branchId = Helper.user.branchId;
    var dateTime = DateTime.now();
    pref.SetPreferencesBool("$slug $branchId ${LocalStorageKey.isCheckIn}", isCheckIn);
    pref.SetPreferencesString("$slug $branchId ${LocalStorageKey.checkInDate}", dateTime.toIso8601String());
  }

  Future<void> GetLastLocation() async {
    var pref = PrefUtils();
    var slug = pref.GetPreferencesString(LocalStorageKey.companySlug);
    var branchId = Helper.user.branchId;
    var isCheckIn = pref.GetPreferencesBool("$slug $branchId ${LocalStorageKey.isCheckIn}");
    if (isCheckIn) {
      var logs = await TravelLogDatabase.dao.SelectSingle("branchId = ${Helper.user.branchId} order by locationDateTime desc limit 1");
      if (logs != null && logs.locationDateTime != null) {
        final DateTime currentTime = DateTime.now();
        final DateTime timeLimit = currentTime.subtract(Duration(minutes: 4));
        if (logs.isIdle == false && logs.locationDateTime!.isBefore(timeLimit)) {
          var trip = await TripDatabase.dao.SelectSingle("branchId = ${Helper.user.branchId} order by id desc limit 1");
          await SetCurrentLocation(isIdle: true, tripId: trip?.id);
          await endTrip();
        }
      }
    }
  }

  Future<void> SetCurrentLocation({bool isIdle = false, int? tripId}) async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      await CreateTravelLog(position, isIdle: isIdle, tripId: tripId);
    } catch (ex) {
      print(ex);
    }
  }

  Future<void> stopService() async {
    final service = FlutterBackgroundService();

    try {
      service.invoke('stopService');
      debugPrint("Service stop invoked successfully.");
    } catch (e) {
      debugPrint("Error stopping service: $e");
    }
  }

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    // Set up a custom notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground',
      'MY FOREGROUND SERVICE',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Initialize notifications for Android and iOS
    if (Platform.isIOS || Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
          android: AndroidInitializationSettings('ic_notification_icon'),
        ),
      );
    }

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        autoStartOnBoot: true,
        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'Background location',
        initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId: 888,
        foregroundServiceTypes: [AndroidForegroundType.location],
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final log = preferences.getStringList('log') ?? <String>[];
    log.add(DateTime.now().toIso8601String());
    await preferences.setStringList('log', log);

    return true;
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) async {
    await flutterLocalNotificationsPlugin.cancel(888); // Cancel notification
    service.stopSelf(); // Stop the service
  });

  // For Android foreground notification
  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      flutterLocalNotificationsPlugin.show(
        888,
        'Background Location Service',
        'Background location tracking is active',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'my_foreground',
            'MY FOREGROUND SERVICE',
            icon: 'ic_notification_icon',
            ongoing: true,
          ),
        ),
      );
    }
  }

  // await initDatabase();
  DatabaseHelper.instance.dataBaseName = "Order-Booker.db";
  await DatabaseHelper.instance.database;
  await PrefUtils().init();
  await Helper.UserData();

  /// you can see this log in logcat
  TravelLogController travelLogController = Get.put(TravelLogController());

  debugPrint('FLUTTER BACKGROUND SERVICE: ${DateTime.now()} ');
  await travelLogController.startTracking();
  final deviceInfo = DeviceInfoPlugin();
  String? device;
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    device = androidInfo.model;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    device = iosInfo.model;
  }

  service.invoke(
    'update',
    {
      "current_date": DateTime.now().toIso8601String(),
      "device": device,
    },
  );
}
