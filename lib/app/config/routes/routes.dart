import 'package:get/route_manager.dart';
import 'package:piu_util/presentation/login/controller/login_binding.dart';
import 'package:piu_util/presentation/login/views/login_page.dart';

import 'route_path.dart';

class Routes {
  static List<GetPage> getPages = [
    GetPage(
      name: RoutePath.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
  ];
}
