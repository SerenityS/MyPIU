import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:piu_util/app/config/app_binding.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/app/config/routes/route_path.dart';
import 'package:piu_util/app/config/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (_, child) {
        return GetMaterialApp(
          theme: ThemeData(
            fontFamily: 'Pretendard',
            appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: AppColor.bg,
              foregroundColor: Colors.white,
              surfaceTintColor: AppColor.bg,
              titleTextStyle: TextStyle(fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.w600),
            ),
            colorSchemeSeed: Colors.redAccent,
            drawerTheme: const DrawerThemeData(
              backgroundColor: AppColor.bg,
              surfaceTintColor: AppColor.bg,
            ),
            listTileTheme: const ListTileThemeData(
              tileColor: AppColor.bg,
              selectedTileColor: AppColor.bg,
              textColor: Colors.white,
            ),
            textTheme: const TextTheme().copyWith(
              displaySmall: const TextStyle(color: Colors.white),
              displayMedium: const TextStyle(color: Colors.white),
              displayLarge: const TextStyle(color: Colors.white),
              bodySmall: const TextStyle(color: Colors.white),
              bodyMedium: const TextStyle(color: Colors.white),
              bodyLarge: const TextStyle(color: Colors.white),
              titleSmall: const TextStyle(color: Colors.white),
              titleMedium: const TextStyle(color: Colors.white),
              titleLarge: const TextStyle(color: Colors.white),
              labelSmall: const TextStyle(color: Colors.white),
              labelMedium: const TextStyle(color: Colors.white),
              labelLarge: const TextStyle(color: Colors.white),
            ),
            scaffoldBackgroundColor: AppColor.bg,
          ),
          builder: (context, child) {
            return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)), child: child!);
          },
          initialBinding: AppBinding(),
          initialRoute: RoutePath.login,
          getPages: Routes.getPages,
        );
      },
    );
  }
}
