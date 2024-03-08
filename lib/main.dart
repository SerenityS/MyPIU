import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:piu_util/app/config/app_binding.dart';
import 'package:piu_util/app/config/routes/route_path.dart';
import 'package:piu_util/app/config/routes/routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialBinding: AppBinding(),
      initialRoute: RoutePath.login,
      getPages: Routes.getPages,
    );
  }
}
