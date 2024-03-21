import 'package:get/get.dart';

import '../entities/chart_data.dart';
import '../entities/play_data.dart';
import '../entities/recently_play_data.dart';
import '../repositories/play_data_repository.dart';

class PlayDataUseCases {
  final PlayDataRepository _repository = Get.find<PlayDataRepository>();

  GetClearData get getClearData => GetClearData(_repository);
  GetPlayData get getPlayData => GetPlayData(_repository);
  GetRecentlyPlayData get getRecentlyPlayData => GetRecentlyPlayData(_repository);
}

class GetClearData {
  final PlayDataRepository _repository;
  GetClearData(this._repository);

  Future<List<ChartData>> execute() async {
    return await _repository.getClearData();
  }
}

class GetPlayData {
  final PlayDataRepository _repository;
  GetPlayData(this._repository);

  Future<List<PlayData>> execute(int level) async {
    return await _repository.getPlayData(level);
  }
}

class GetRecentlyPlayData {
  final PlayDataRepository _repository;
  GetRecentlyPlayData(this._repository);

  Future<List<RecentlyPlayData>> execute() async {
    return await _repository.getRecentlyPlayData();
  }
}
