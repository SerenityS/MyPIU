import 'chart_data.dart';

class RatingData {
  final int level;
  int singleCount;
  int doubleCount;
  List<ChartData> clearData = [];
  int singleRating;
  int doubleRating;

  RatingData(this.level, this.singleCount, this.doubleCount, this.singleRating, this.doubleRating);
}
