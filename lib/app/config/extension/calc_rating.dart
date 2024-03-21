import 'package:piu_util/domain/entities/chart_data.dart';

extension CalcRating on ChartData {
  int rating() {
    int levelPrefix = 100;

    for (int i = 0; i <= level - 10; i++) {
      levelPrefix += 10 * i;
    }

    return (levelPrefix * gradeType.ratingPrefix).round();
  }
}
