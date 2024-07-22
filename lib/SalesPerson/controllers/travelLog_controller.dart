import 'dart:async';
import 'dart:developer';

import 'package:sa_common/Controller/BaseController.dart';
import 'package:location/location.dart' as l;
import 'package:permission_handler/permission_handler.dart';
import 'package:sa_common/SalesPerson/database/travelLog_database.dart';
import 'package:sa_common/SalesPerson/model/TravelLogModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Helper.dart';

class TravelLogController extends BaseController {
  bool gpsEnabled = false;
  bool permissionGranted = false;
  l.Location location = l.Location();
  late StreamSubscription subscription;
  bool trackingEnabled = false;
  List<l.LocationData> locations = [];

  @override
  Future<void> onInit() async {
    location.isBackgroundModeEnabled();
    super.onInit();
  }

  checkStatus() async {
    bool _permissionGranted = await isPermissionGranted();
    bool _gpsEnabled = await isGpsEnabled();
    permissionGranted = _permissionGranted;
    gpsEnabled = _gpsEnabled;
    
  }

  Future<bool> isPermissionGranted() async {
    return await Permission.locationWhenInUse.isGranted;
  }

  Future<bool> isGpsEnabled() async {
    return await Permission.location.serviceStatus.isEnabled;
  }

  addLocation(l.LocationData data) {
    locations.insert(0, data);
  }

  void startTracking() async {
    if (!(await isGpsEnabled())) {
      return;
    }
    if (!(await isPermissionGranted())) {
      return;
    }
    location.enableBackgroundMode();
    location.changeSettings(distanceFilter: 25);
    subscription = location.onLocationChanged.listen((event) async {
     await CreateTravelLog(event);
     
    });
    trackingEnabled = true;
  }

  void stopTracking() {
    subscription.cancel();
    trackingEnabled = false;
    clearLocation();
  }

  clearLocation() {
    locations.clear();
  }

  void requestEnableGps() async {
    if (gpsEnabled) {
      log("Already open");
    } else {
      bool isGpsActive = await location.requestService();
      location.enableBackgroundMode();
      if (!isGpsActive) {
        gpsEnabled = false;
        log("User did not turn on GPS");
      } else {
        log("gave permission to the user and opened it");
        gpsEnabled = true;
      }
    }
  }

  void requestLocationPermission() async {
    PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.request();
    if (permissionStatus == PermissionStatus.granted) {
      permissionGranted = true;
    } else {
      permissionGranted = false;
    }
  }
  Future<void> CreateTravelLog(l.LocationData event) async {
     TravelLogModel travelLog = TravelLogModel(
        speed: event.speed ?? 0.0,
        latitude: event.latitude ?? 0.0,
        longitude: event.longitude ?? 0.0,
        locationDateTime: DateTime.now(),
        heading: event.heading ?? 0.0,
        altitude: event.altitude ?? 0.0,
        altitudeAccuracy: event.speedAccuracy ?? 0.0,
        applicationUserId: Helper.user.userId,
        branchId: Helper.user.branchId,
      );
      await TravelLogDatabase.dao.insert(travelLog);
  }
  Future <void> SyncToServerTravelLog() async {
    var logs = await TravelLogDatabase.dao.SelectList("isSync = 0");
    if(logs != null && logs.isNotEmpty){
    //  var losModel = TravelLogModel().ToJson(data: logs);
    //  var response = await this.baseClient.post(ApiEndPoint.baseUrl, "the-next-generation/1898/", logs);
    }
  }
 }
