import 'package:get/route_manager.dart';
import 'package:piu_util/presentation/avatar/controller/avatar_binding.dart';
import 'package:piu_util/presentation/home/controller/home_binding.dart';
import 'package:piu_util/presentation/home/views/home_page.dart';
import 'package:piu_util/presentation/home/views/setting_page.dart';
import 'package:piu_util/presentation/home/views/term_page.dart';
import 'package:piu_util/presentation/login/controller/login_binding.dart';
import 'package:piu_util/presentation/login/views/login_page.dart';
import 'package:piu_util/presentation/play_data/controller/play_data_binding.dart';
import 'package:piu_util/presentation/title/controller/title_binding.dart';

import 'route_path.dart';

class Routes {
  static List<GetPage> getPages = [
    // Login
    GetPage(
      name: RoutePath.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),

    // Home
    GetPage(
      name: RoutePath.home,
      page: () => const HomePage(),
      bindings: [
        HomeBinding(),
        AvatarBinding(),
        PlayDataBinding(),
        TitleBinding(),
      ],
    ),

    // Setting
    GetPage(
      name: RoutePath.setting,
      page: () => const SettingPage(),
    ),
    GetPage(
      name: RoutePath.term,
      page: () => TermPage(),
    ),
  ];
}
