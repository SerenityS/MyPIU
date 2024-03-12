extension ScoreToString on int {
  String toScoreString() {
    double score = this / 10000;
    score = (score * 10).floor() / 10;

    return score.toStringAsFixed(1);
  }
}
