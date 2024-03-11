import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:piu_util/domain/entities/chart_data.dart';

class AvatarDataLocalDataSource {
  final box = Hive.box('avatar');
  final String _key = 'avatar';

  Future<void> deleteAvatarData() async {
    await box.delete(_key);
  }

  List<ChartData>? getAvatarData() {
    final avatarData = box.get(_key);

    if (avatarData != null) {
      return (jsonDecode(avatarData) as List).map((e) => ChartData.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  Future<void> saveAvatarData(List<ChartData> avatarData) async {
    await box.put(_key, jsonEncode(avatarData));
  }
}
