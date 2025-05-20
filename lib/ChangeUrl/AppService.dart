// lib/services/app_service.dart
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppService {
  static const String urlKey = LocalStorageKey.baseUrl;
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get appUrl => _prefs.getString(urlKey) ?? ApiEndPoint.url;

  Future<void> setAppUrl(String url) async {
    await _prefs.setString(urlKey, url);
  }
}
