import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static const String TOKEN_KEY = "oneDriveUserToken";
  static const String FIRST_LAUNCH = "isFirstLaunch";

  static SharedPreference _instance;

  factory SharedPreference() => _getInstance();

  static SharedPreference get instance => _getInstance();

  static SharedPreference _getInstance() {
    if (_instance == null) {
      _instance = new SharedPreference._internalConstructor();
    }
    return _instance;
  }

  SharedPreference._internalConstructor();

  SharedPreferences _prefs;

  initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> putData(String key, String value) async {
    bool result = await _prefs.setString(key, value);
    return result;
  }

  String getData(String key) {
    String result = _prefs.getString(key);
    return result;
  }
}
