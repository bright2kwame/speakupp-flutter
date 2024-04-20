import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceModule {
  final SharedPreferences pref;
  static const String _userToken = "user_data";

  SharedPreferenceModule({required this.pref});

  void clear() => pref.clear();

  void saveUserData(String userAuthToken) =>
      pref.setString(_userToken, userAuthToken);

//MARK: save data
  void saveData(String key, String data) => pref.setString(key, data);

//MARK: save bool data
  void saveBoolData(String key, bool data) => pref.setBool(key, data);

//MARK: retrieve data
  String getData(String key) {
    String dataInJson = pref.getString(key) ?? "";
    return dataInJson;
  }

//MARK: retrieve data
  bool getBoolData(String key) {
    bool dataInJson = pref.getBool(key) ?? false;
    return dataInJson;
  }

  String getUserData() {
    String userDataInJson = pref.getString(_userToken) ?? "";
    return userDataInJson;
  }
}
