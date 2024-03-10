import 'package:get/get.dart';

import '../entities/my_data.dart';
import '../repositories/my_data_repository.dart';

class MyDataUseCases {
  final MyDataRepository _repository = Get.find<MyDataRepository>();

  GetMyData get getMyData => GetMyData(_repository);
}

class GetMyData {
  final MyDataRepository _repository;
  GetMyData(this._repository);

  Future<List<MyData>> execute() async {
    return await _repository.getMyData();
  }
}
