import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:piu_util/domain/entities/title_data.dart';

class TitleLocalDataSource {
  final box = Hive.box('title');
  final String _titleDataKey = 'title';

  Future<void> deleteTitleData() async {
    await box.delete(_titleDataKey);
  }

  List<TitleData> getTitleData() {
    final titleData = box.get(_titleDataKey);

    if (titleData != null) {
      return (jsonDecode(titleData) as List).map((e) => TitleData.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<void> saveTitleData(List<TitleData> titleData) async {
    await box.put(_titleDataKey, jsonEncode(titleData));
  }
}
