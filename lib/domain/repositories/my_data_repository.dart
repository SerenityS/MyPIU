import '../entities/my_data.dart';

abstract class MyDataRepository {
  Future<List<MyData>> getMyData();
}
