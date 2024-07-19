import 'dart:async';

import 'package:sa_common/Controller/BaseController.dart';
import 'package:location/location.dart' as l;
import 'package:permission_handler/permission_handler.dart';

class TravelLogController extends BaseController {
  bool gpsEnabled = false;
  bool permissionGranted = false;
  l.Location location = l.Location();
  late StreamSubscription subscription;
  bool trackingEnabled = false;
  List<l.LocationData> locations = [];
  
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
  
  void startTracking() async {
    if (!(await isGpsEnabled())) {
      return;
    }
    if (!(await isPermissionGranted())) {
      return;
    }
    location.changeSettings(distanceFilter: 5);
    subscription = location.onLocationChanged.listen((event) {
      print(event);
      // Save Db Work
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
} 