import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' show parse;

import 'package:piu_util/app/config/app_url.dart';
import 'package:piu_util/app/config/extension/get_file_name_extension.dart';
import 'package:piu_util/app/network/builder/dio_builder.dart';
import 'package:piu_util/domain/entities/my_data.dart';
import 'package:piu_util/domain/entities/title_data.dart';
import 'package:piu_util/domain/enum/title_type.dart';
import 'package:piu_util/domain/repositories/my_data_repository.dart';

class MyDataRepositoryImpl extends MyDataRepository {
  final Dio _dio = Get.find<DioBuilder>();

  @override
  Future<List<MyData>> getMyData() async {
    await _dio.post(AppUrl.setLanguageUrl, data: {"lang": "kr"});
    var response = await _dio.get(AppUrl.playDataUrl);

    return parseMyData(response.data);
  }

  @override
  Future<List<TitleData>> getTitleData() async {
    var response = await _dio.get(AppUrl.getTitleUrl);

    return parseTitleData(response.data);
  }

  @override
  Future<bool> setTitle(String id) async {
    try {
      await _dio.post(AppUrl.setTitleUrl, data: {"no": id});
      return true;
    } catch (e) {
      return false;
    }
  }
}

List<MyData> parseMyData(String html) {
  List<MyData> myDataList = [];

  var document = parse(html);
  var parsedMyData = document.getElementsByClassName("game_id_informationList flex wrap");

  for (var myData in parsedMyData[1].getElementsByClassName("in_profile")) {
    int id = int.parse(myData.getElementsByTagName("input").first.attributes["value"] ?? '0');

    var profile = myData.getElementsByClassName("name_w").first.getElementsByTagName("p");
    String nickname = profile[1].text;
    String titleText = profile[0].text;
    String titleStyle = profile[0].attributes["class"] ?? 'col5';

    String avatar = myData.getElementsByClassName("re bgfix").first.attributes["style"]?.getFileNameExtension() ?? "";

    int coin = int.parse(myData.getElementsByClassName("tt en").first.text.replaceAll(',', ''));

    String recentPlayDate = myData.getElementsByClassName("tt")[1].text.split(' : ')[1];
    String recentPlayPlace = myData.getElementsByClassName("tt")[2].text.split(' : ')[1];

    int totalClear = int.tryParse(
          document.getElementsByClassName("l_con").first.getElementsByClassName("t1").first.text.split("/").first.replaceAll(",", ""),
        ) ??
        0;

    myDataList.add(
      MyData(
        id: id,
        nickname: nickname,
        avatar: avatar,
        titleType: TitleType.fromString(titleStyle),
        titleText: titleText,
        coin: coin,
        recentPlayDate: recentPlayDate,
        recentPlayPlace: recentPlayPlace,
        totalClear: totalClear,
      ),
    );
  }

  return myDataList;
}

List<TitleData> parseTitleData(String html) {
  List<TitleData> titleDataList = [];

  var document = parse(html);
  var parsedTitleData = document.getElementsByClassName("data_titleList2 flex wrap");

  for (var titleData in parsedTitleData.first.getElementsByTagName("li")) {
    String id = titleData.getElementsByTagName("input").firstOrNull?.attributes["value"] ?? '';
    String title = titleData.getElementsByClassName("txt").first.text;
    String titleType = titleData.getElementsByTagName("p").first.attributes["class"] ?? 'col5';
    String description = titleData.getElementsByClassName("txt").last.text;
    bool hasTitle = titleData.attributes["class"]!.contains("have") ? true : false;
    bool isEnable = titleData.getElementsByTagName("button").first.attributes["class"]!.contains("bg2") ? true : false;

    titleDataList.add(
      TitleData(
        id: id,
        titleText: title,
        titleType: TitleType.fromString(titleType),
        description: description,
        hasTitle: hasTitle,
        isEnable: isEnable,
      ),
    );
  }

  return titleDataList;
}
