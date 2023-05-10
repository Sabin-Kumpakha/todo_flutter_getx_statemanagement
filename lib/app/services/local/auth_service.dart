import 'package:get/get.dart';
import 'package:todo/app/services/local/storage_service.dart';

import '../../routes/app_pages.dart';

//GetXService benefit is that it is a singleton class and it is initialized only once in the app life cycle.
class AuthService extends GetxService {
  Future logout() async {
    StorageService storageService = Get.find();
    await storageService.deleteAccessToken();
    await storageService.deleteRefreshToken();
    Get.offAndToNamed(Routes.LOGIN);
  }
}
