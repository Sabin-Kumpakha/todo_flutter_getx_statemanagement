import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/services/local/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StorageService storageService = Get.put(StorageService());
  await storageService.init();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: storageService.getAccessToken() == null
          ? AppPages.INITIAL
          : Routes.HOME,
      getPages: AppPages.routes,
    ),
  );
}
