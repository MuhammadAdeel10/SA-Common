import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/Logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    Logger.InfoLog('SharedPreference Initialized');
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  void clearPreferencesDataKey(String key) async {
    _sharedPreferences!.remove(key);
  }

  int GetCompanyCount() {
    return _sharedPreferences?.getInt(LocalStorageKey.companyCount) ?? 0;
  }

  int GetBranchCount() {
    return _sharedPreferences?.getInt(LocalStorageKey.brachCount) ?? 0;
  }

  void SetBranchCount(int value) {
    _sharedPreferences?.setInt(LocalStorageKey.brachCount, value);
  }

  void SetCompanyCount(int value) {
    _sharedPreferences?.setInt(LocalStorageKey.companyCount, value);
  }

  void SetPreferencesInteger(String key, int value) {
    _sharedPreferences?.setInt(key, value);
  }

  void SetPreferencesString(String key, String value) {
    _sharedPreferences?.setString(key, value);
  }

  int GetPreferencesInteger(String key) {
    return _sharedPreferences?.getInt(key) ?? 0;
  }

  String GetPreferencesString(String key) {
    return _sharedPreferences?.getString(key) ?? "";
  }

  void ClearCustomerNameUpdate(int screenType) {
    if (screenType == 1) {
      clearPreferencesDataKey(LocalStorageKey.screen1CustomerName);
      clearPreferencesDataKey(LocalStorageKey.screen1CustomerId);
      clearPreferencesDataKey(LocalStorageKey.screen1SalesPersonName);
      clearPreferencesDataKey(LocalStorageKey.screen1SalesPersonId);
    } else if (screenType == 2) {
      clearPreferencesDataKey(LocalStorageKey.screen2CustomerName);
      clearPreferencesDataKey(LocalStorageKey.screen2CustomerId);
      clearPreferencesDataKey(LocalStorageKey.screen2SalesPersonName);
      clearPreferencesDataKey(LocalStorageKey.screen2SalesPersonId);
    } else if (screenType == 3) {
      clearPreferencesDataKey(LocalStorageKey.screen3CustomerName);
      clearPreferencesDataKey(LocalStorageKey.screen3CustomerId);
      clearPreferencesDataKey(LocalStorageKey.screen3SalesPersonName);
      clearPreferencesDataKey(LocalStorageKey.screen3SalesPersonId);
    }
  }

  void CustomerNameUpdate(int screenType) {
    if (screenType == 1) {
      SetPreferencesInteger(LocalStorageKey.screen1CustomerId, 0);
      SetPreferencesString(LocalStorageKey.screen1CustomerName, "");
      SetPreferencesInteger(LocalStorageKey.screen1SalesPersonId, 0);
      SetPreferencesString(LocalStorageKey.screen1SalesPersonName, "");
    } else if (screenType == 2) {
      SetPreferencesInteger(LocalStorageKey.screen2CustomerId, 0);
      SetPreferencesString(LocalStorageKey.screen2CustomerName, "");
      SetPreferencesInteger(LocalStorageKey.screen2SalesPersonId, 0);
      SetPreferencesString(LocalStorageKey.screen2SalesPersonName, "");
    } else {
      SetPreferencesInteger(LocalStorageKey.screen3CustomerId, 0);
      SetPreferencesString(LocalStorageKey.screen3CustomerName, "");
      SetPreferencesInteger(LocalStorageKey.screen3SalesPersonId, 0);
      SetPreferencesString(LocalStorageKey.screen3SalesPersonName, "");
    }
  }

  void OnlyCustomerNameAndId(int screenType) {
    if (screenType == 1) {
      clearPreferencesDataKey(LocalStorageKey.screen1CustomerName);
      clearPreferencesDataKey(LocalStorageKey.screen1CustomerId);
    } else if (screenType == 2) {
      clearPreferencesDataKey(LocalStorageKey.screen2CustomerName);
      clearPreferencesDataKey(LocalStorageKey.screen2CustomerId);
    } else if (screenType == 3) {
      clearPreferencesDataKey(LocalStorageKey.screen3CustomerName);
      clearPreferencesDataKey(LocalStorageKey.screen3CustomerId);
    }
  }

  void OnlySalesPersonNameAndId(int screenType) {
    if (screenType == 1) {
      clearPreferencesDataKey(LocalStorageKey.screen1SalesPersonName);
      clearPreferencesDataKey(LocalStorageKey.screen1SalesPersonId);
    } else if (screenType == 2) {
      clearPreferencesDataKey(LocalStorageKey.screen2SalesPersonName);
      clearPreferencesDataKey(LocalStorageKey.screen2SalesPersonId);
    } else if (screenType == 3) {
      clearPreferencesDataKey(LocalStorageKey.screen3SalesPersonName);
      clearPreferencesDataKey(LocalStorageKey.screen3SalesPersonId);
    }
  }
}
