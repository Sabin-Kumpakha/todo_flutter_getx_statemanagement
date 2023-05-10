// storage service
// camera service
// language service
// theme service

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _sharedPreferences;

  Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future storeAccessToken({required String accessToken}) async {
    await _sharedPreferences.setString("accessToken", accessToken);
  }

  getAccessToken() {
    return _sharedPreferences.getString("accessToken");
  }

  deleteAccessToken() async {
    await _sharedPreferences.remove("accessToken");
  }

  Future storeRefreshToken({required String refreshToken}) async {
    await _sharedPreferences.setString("refreshToken", refreshToken);
  }

  getRefreshToken() {
    return _sharedPreferences.getString("refreshToken");
  }

  deleteRefreshToken() async {
    await _sharedPreferences.remove("refreshToken");
  }
}
