import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:piu_util/domain/entities/avatar_data.dart';

class AvatarDataLocalDataSource {
  final box = Hive.box('myData');
  final String _key = 'avatar';

  Future<void> deleteAvatarData() async {
    await box.delete(_key);
  }

  List<AvatarData> getAvatarData() {
    final avatarData = box.get(_key);

    if (avatarData != null) {
      return (jsonDecode(avatarData) as List).map((e) => AvatarData.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<void> saveAvatarData(List<AvatarData> avatarData) async {
    await box.put(_key, jsonEncode(avatarData));
  }
}
