import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' show parse;
import 'package:piu_util/app/network/builder/dio_builder.dart';

import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/entities/play_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/enum/grade_type.dart';
import 'package:piu_util/domain/enum/plate_type.dart';
import 'package:piu_util/domain/repositories/play_data_repository.dart';

class PlayDataRepositoryImpl extends PlayDataRepository {
  final Dio _dio = Get.find<DioBuilder>();

  @override
  Future<List<ChartData>> getMyBestScore(int level) async {
    if (level < 10) throw Exception("Level must be 10 or higher");

    // Request first page to get total page count
    var firstPageResponse = await _dio.get("/my_page/my_best_score.php?lv=$level&page=1");
    if (firstPageResponse.statusCode != 200) {
      throw Exception("Failed to get best score");
    }

    int totalPages = (getClearDataPageIndex(firstPageResponse.data) / 12).ceil();
    List<ChartData> chartDataList = parseClearData(firstPageResponse.data, level);

    // Request the rest of the pages with parallel requests
    List<Future> requests = [];
    for (int pageIndex = 2; pageIndex <= totalPages; pageIndex++) {
      requests.add(_dio.get("/my_page/my_best_score.php?lv=$level&page=$pageIndex"));
    }

    var responses = await Future.wait(requests);

    for (var response in responses) {
      if (response.statusCode == 200) {
        chartDataList.addAll(parseClearData(response.data, level));
      } else {
        throw Exception("Failed to get best score from one of the pages");
      }
    }

    return chartDataList;
  }

  @override
  Future<List<PlayData>> getPlayData(int level) {
    // TODO: implement getPlayData
    throw UnimplementedError();
  }
}

int getClearDataPageIndex(String html) {
  var document = parse(html);
  var bestScoreLength = document.getElementsByClassName("tt t2");
  return int.parse(bestScoreLength[0].text);
}

List<ChartData> parseClearData(String html, int level) {
  final List<ChartData> clearDataList = [];

  var document = parse(html);

  var parsedClearData = document.getElementsByClassName("my_best_scoreList flex wrap");
  for (var scoreData in parsedClearData[0].getElementsByClassName("in")) {
    String chartType = scoreData.getElementsByTagName("img")[0].attributes["src"]!;
    String title = scoreData.getElementsByClassName("song_name")[0].text;
    int score = int.parse(scoreData.getElementsByClassName("txt_v")[0].text.replaceAll(",", ""));
    String gradeType = scoreData.getElementsByTagName("img")[3].attributes["src"]!;
    String plateType = scoreData.getElementsByTagName("img")[4].attributes["src"]!;

    clearDataList.add(
      ChartData(
        title: title,
        score: score,
        level: level,
        chartType: ChartType.fromString(chartType),
        gradeType: GradeType.fromString(gradeType),
        plateType: PlateType.fromString(plateType),
      ),
    );
  }

  return clearDataList;
}
