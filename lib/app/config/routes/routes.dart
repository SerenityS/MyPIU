import 'package:get/route_manager.dart';
import 'package:piu_util/presentation/avatar/view_models/avatar_binding.dart';
import 'package:piu_util/presentation/home/view_models/home_binding.dart';
import 'package:piu_util/presentation/home/views/home_page.dart';
import 'package:piu_util/presentation/setting/view_models/setting_binding.dart';
import 'package:piu_util/presentation/setting/views/licences_page.dart';
import 'package:piu_util/presentation/setting/views/setting_page.dart';
import 'package:piu_util/presentation/login/view_models/login_binding.dart';
import 'package:piu_util/presentation/login/views/login_page.dart';
import 'package:piu_util/presentation/play_data/view_models/play_data_binding.dart';
import 'package:piu_util/presentation/title/view_models/title_binding.dart';

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
      binding: SettingBinding(),
    ),
    GetPage(
      name: RoutePath.licences,
      page: () => const LicencesPage(),
    ),
  ];
}
