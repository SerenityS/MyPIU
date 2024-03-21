import '../entities/chart_data.dart';
import '../entities/play_data.dart';
import '../entities/recently_play_data.dart';

abstract class PlayDataRepository {
  Future<List<ChartData>> getClearData();
  Future<List<PlayData>> getPlayData(int level);
  Future<List<RecentlyPlayData>> getRecentlyPlayData();
}
