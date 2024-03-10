import '../entities/chart_data.dart';
import '../entities/play_data.dart';

abstract class PlayDataRepository {
  Future<List<ChartData>> getBestScore();
  Future<List<PlayData>> getPlayData(int level);
}
