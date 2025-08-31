import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static String userIdKey = 'USERIDKEY';
  static String userNameKey = 'USERNAMEKEY';
  static String userEmailKey = 'USEREMAILKEY';
  static String userImageKey = 'USERIMAGEKEY';
  static String isFirstTimeKey = 'ISFIRSTTIMEKEY';
  static String isLoggedInKey = 'ISLOGGEDINKEY';
  static String isAdminLoggedInKey = 'ISADMINLOGGEDINKEY';

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> saveIsAdminLoggedIn(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool(isAdminLoggedInKey, value);
  }

  Future<bool?> getIsAdminLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(isAdminLoggedInKey);
  }

  Future<void> clearAdminLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(isAdminLoggedInKey);
  }

  Future<bool> saveIsFirstTime(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool(isFirstTimeKey, value);
  }

  Future<bool?> getIsFirstTime() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(isFirstTimeKey);
  }

  Future<bool> saveIsLoggedIn(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool(isLoggedInKey, value);
  }

  Future<bool?> getIsLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(isLoggedInKey);
  }

  Future<void> clearPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserImage(String getUserImage) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userImageKey, getUserImage);
  }

  Future<String?> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userEmailKey);
  }

  Future<String?> getUserImage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userImageKey);
  }
}
