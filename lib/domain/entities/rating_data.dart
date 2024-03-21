import 'chart_data.dart';

class RatingData {
  final int level;
  int singleCount;
  int doubleCount;
  int singleRating;
  int doubleRating;
  List<ChartData> clearData = [];

  RatingData(this.level, this.singleCount, this.doubleCount, this.singleRating, this.doubleRating);
}
