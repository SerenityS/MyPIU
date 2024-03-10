import 'package:get/get.dart';

import '../entities/my_data.dart';
import '../entities/title_data.dart';
import '../repositories/my_data_repository.dart';

class MyDataUseCases {
  final MyDataRepository _repository = Get.find<MyDataRepository>();

  GetMyData get getMyData => GetMyData(_repository);
  GetTitleData get getTitleData => GetTitleData(_repository);
  SetTitle get setTitle => SetTitle(_repository);
}

class GetMyData {
  final MyDataRepository _repository;
  GetMyData(this._repository);

  Future<List<MyData>> execute() async {
    return await _repository.getMyData();
  }
}

class GetTitleData {
  final MyDataRepository _repository;
  GetTitleData(this._repository);

  Future<List<TitleData>> execute() async {
    return await _repository.getTitleData();
  }
}

class SetTitle {
  final MyDataRepository _repository;
  SetTitle(this._repository);

  Future<bool> execute(String id) async {
    return await _repository.setTitle(id);
  }
}
