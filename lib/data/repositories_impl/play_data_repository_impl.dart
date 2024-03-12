import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:piu_util/app/config/app_url.dart';
import 'package:piu_util/app/config/extension/get_file_name_extension.dart';
import 'package:piu_util/app/network/builder/dio_builder.dart';

import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/entities/play_data.dart';
import 'package:piu_util/domain/entities/recently_play_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/enum/grade_type.dart';
import 'package:piu_util/domain/enum/plate_type.dart';
import 'package:piu_util/domain/repositories/play_data_repository.dart';
import 'package:piu_util/presentation/play_data/controller/play_data_controller.dart';

class PlayDataRepositoryImpl extends PlayDataRepository {
  final Dio _dio = Get.find<DioBuilder>();

  Iterable<List<T>> chunk<T>(List<T> list, int size) sync* {
    for (var i = 0; i < list.length; i += size) {
      yield list.sublist(i, i + size > list.length ? list.length : i + size);
    }
  }

  @override
  Future<List<ChartData>> getBestScore() async {
    var firstPageResponse = await _dio.get("${AppUrl.bestScoreUrl}?&page=1");

    if (firstPageResponse.statusCode != 200) {
      throw Exception("Failed to get best score");
    }

    // Assuming getClearDataPageIndex and parseClearData are defined elsewhere
    int totalPages = (getClearDataPageIndex(firstPageResponse.data) / 12).ceil();

    final PlayDataController playDataController = Get.find<PlayDataController>();
    playDataController.totalPageIndex.value = totalPages - 1;

    List<ChartData> chartDataList = parseClearData(firstPageResponse.data);

    // Create a list for all page requests but initiate requests in chunks of 4
    List<int> allPages = List.generate(totalPages - 1, (i) => i + 2); // Pages 2 through totalPages
    List<List<int>> pageChunks = chunk(allPages, 4).toList();

    for (var chunk in pageChunks) {
      List<Future> requests = chunk.map((pageIndex) => _dio.get("${AppUrl.bestScoreUrl}?&page=$pageIndex")).toList();

      var responses = await Future.wait(requests);

      for (var response in responses) {
        if (response.statusCode == 200) {
          chartDataList.addAll(parseClearData(response.data));
          playDataController.currentLoadingPageIndex.value++;
        } else {
          throw Exception("Failed to get best score from one of the pages");
        }
      }
    }

    playDataController.totalPageIndex.value = 0;
    playDataController.currentLoadingPageIndex.value = 0;

    return chartDataList;
  }

  @override
  Future<List<PlayData>> getPlayData(int level) {
    // TODO: implement getPlayData
    throw UnimplementedError();
  }

  @override
  Future<List<RecentlyPlayData>> getRecentlyPlayData() async {
    var response = await _dio.get(AppUrl.recentlyPlayDataUrl);

    if (response.statusCode != 200) {
      throw Exception("Failed to get recently play data");
    }

    return parseRecentlyPlayData(response.data);
  }
}

int getClearDataPageIndex(String html) {
  var document = parse(html);
  var bestScoreLength = document.getElementsByClassName("tt t2");
  return int.parse(bestScoreLength[0].text);
}

List<ChartData> parseClearData(String html) {
  final List<ChartData> clearDataList = [];

  var document = parse(html);

  List<Element>? parsedClearData = document.getElementsByClassName("my_best_scoreList flex wrap").firstOrNull?.getElementsByClassName("in");

  if (parsedClearData == null) return clearDataList;

  for (var scoreData in parsedClearData) {
    String title = scoreData.getElementsByClassName("song_name")[0].text;
    int score = int.parse(scoreData.getElementsByClassName("txt_v")[0].text.replaceAll(",", ""));
    String level1 = scoreData.getElementsByTagName("img")[1].attributes["src"]!;
    String level2 = scoreData.getElementsByTagName("img")[2].attributes["src"]!;
    String chartType = scoreData.getElementsByTagName("img")[0].attributes["src"]!;
    String gradeType = scoreData.getElementsByTagName("img")[3].attributes["src"]!;
    String plateType = scoreData.getElementsByTagName("img")[4].attributes["src"]!;

    if (level1.contains("u_num_x")) {
      continue; // Skip UCS clear data
    } else if (level1.contains("c_icon")) {
      level1 = "https://piugame.com/l_img/stepball/full/c_num_0.png"; // Hack for COOP chart
    }

    clearDataList.add(
      ChartData(
        title: title,
        score: score,
        level: int.parse(level1.substring(level1.length - 5, level1.length - 4) + level2.substring(level2.length - 5, level2.length - 4)),
        chartType: ChartType.fromString(chartType),
        gradeType: GradeType.fromString(gradeType),
        plateType: PlateType.fromString(plateType),
      ),
    );
  }

  return clearDataList;
}

List<RecentlyPlayData> parseRecentlyPlayData(String html) {
  List<RecentlyPlayData> recentlyPlayDataList = [];

  var document = parse(html);

  List<Element>? parsedRecentlyPlayData =
      document.getElementsByClassName("recently_playeList flex wrap").firstOrNull?.getElementsByClassName("wrap_in");

  if (parsedRecentlyPlayData == null) return recentlyPlayDataList;

  for (var recentlyData in parsedRecentlyPlayData) {
    String jacketFileName = recentlyData.getElementsByClassName("in bgfix").first.attributes["style"]!.getFileNameExtension();
    String title = recentlyData.getElementsByClassName("song_name flex").first.getElementsByTagName("p").first.text;
    String chartType = recentlyData.getElementsByTagName("img")[0].attributes["src"]!;
    String level1 = recentlyData.getElementsByTagName("img")[1].attributes["src"]!;
    String level2 = recentlyData.getElementsByTagName("img")[2].attributes["src"]!;

    var gradeData = recentlyData.getElementsByClassName("li_in ac").first;
    String? gradeType = gradeData.getElementsByTagName("img").firstOrNull?.attributes["src"];
    int? score = int.tryParse(gradeData.getElementsByClassName("tx").first.text.replaceAll(",", ""));
    String? plateType = recentlyData.getElementsByClassName("li_in st1").firstOrNull?.getElementsByTagName("img").first.attributes["src"];

    int perfect =
        int.parse(recentlyData.getElementsByClassName("fontCol fontCol1").first.getElementsByTagName("div").first.text.replaceAll(",", ""));
    int great =
        int.parse(recentlyData.getElementsByClassName("fontCol fontCol2").first.getElementsByTagName("div").first.text.replaceAll(",", ""));
    int good =
        int.parse(recentlyData.getElementsByClassName("fontCol fontCol3").first.getElementsByTagName("div").first.text.replaceAll(",", ""));
    int bad =
        int.parse(recentlyData.getElementsByClassName("fontCol fontCol4").first.getElementsByTagName("div").first.text.replaceAll(",", ""));
    int miss =
        int.parse(recentlyData.getElementsByClassName("fontCol fontCol5").first.getElementsByTagName("div").first.text.replaceAll(",", ""));

    String playDate = recentlyData.getElementsByClassName("recently_date_tt").first.text.replaceAll(" (GMT+9)", "");

    recentlyPlayDataList.add(
      RecentlyPlayData(
        title: title,
        jacketFileName: jacketFileName,
        level: int.parse(level1.substring(level1.length - 5, level1.length - 4) + level2.substring(level2.length - 5, level2.length - 4)),
        chartType: ChartType.fromString(chartType),
        gradeType: gradeType!.isEmpty ? null : GradeType.fromString(gradeType),
        score: score,
        plateType: plateType != null ? PlateType.fromString(plateType) : null,
        perfect: perfect,
        great: great,
        good: good,
        bad: bad,
        miss: miss,
        playDate: DateTime.parse(playDate),
      ),
    );
  }

  return recentlyPlayDataList;
}
