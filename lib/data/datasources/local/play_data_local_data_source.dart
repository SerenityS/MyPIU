import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:piu_util/domain/entities/chart_data.dart';

class PlayDataLocalDataSource {
  final box = Hive.box('play_data');
  final String _clearDataKey = 'clear_data';

  Future<void> deleteClearData() async {
    await box.delete(_clearDataKey);
  }

  List<ChartData>? getClearData() {
    final playData = box.get(_clearDataKey);

    if (playData != null) {
      return (jsonDecode(playData) as List).map((e) => ChartData.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  Future<void> saveClearData(List<ChartData> clearData) async {
    await box.put(_clearDataKey, jsonEncode(clearData));
  }
}
