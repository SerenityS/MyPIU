import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' show parse;
import 'package:piu_util/app/config/app_url.dart';
import 'package:piu_util/app/config/extension/get_file_name_extension.dart';
import 'package:piu_util/app/network/builder/dio_builder.dart';
import 'package:piu_util/domain/entities/avatar_data.dart';
import 'package:piu_util/domain/repositories/avatar_repository.dart';

class AvatarRepositoryImpl extends AvatarRepository {
  final Dio _dio = Get.find<DioBuilder>();

  @override
  Future<bool> buyAvatar(String id) {
    try {
      _dio.post(AppUrl.buyAvatarUrl, data: {"no": id});
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<List<AvatarData>> getAvatars() async {
    var response = await _dio.get(AppUrl.getAvatarUrl);

    return parseAvatarData(response.data);
  }

  @override
  Future<bool> setAvatar(String id) {
    try {
      _dio.post(AppUrl.setAvatarUrl, data: {"no": id});
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}

List<AvatarData> parseAvatarData(String html) {
  List<AvatarData> avatarDataList = [];

  var document = parse(html);
  var parsedTitleData = document.getElementsByClassName("avatar_shopList2 flex wrap");

  for (var titleData in parsedTitleData.first.getElementsByTagName("li")) {
    String id = titleData.getElementsByTagName("input").firstOrNull?.attributes["value"] ?? '';
    String name = titleData.getElementsByClassName("name_t").first.text;
    String fileName = titleData.getElementsByClassName("re img bgfix").first.attributes["style"]?.getFileNameExtension() ?? '';
    int coin = int.parse(titleData.getElementsByClassName("tt en").firstOrNull?.text ?? "0");
    String status = titleData.attributes["class"]!;
    bool isEnable = titleData.getElementsByTagName("button").first.attributes["class"]!.contains("bg2") ? true : false;

    avatarDataList.add(
      AvatarData(
        id: id,
        name: name,
        fileName: fileName,
        requiredCoin: coin,
        status: status,
        isEnable: isEnable,
      ),
    );
  }

  return avatarDataList;
}
