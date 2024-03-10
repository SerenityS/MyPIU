import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:piu_util/app/config/app_binding.dart';
import 'package:piu_util/app/config/routes/route_path.dart';
import 'package:piu_util/app/config/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  Hive.init((await getApplicationDocumentsDirectory()).path);
  await Hive.openBox('play_data');

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
