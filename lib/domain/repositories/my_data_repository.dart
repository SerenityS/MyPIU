import '../entities/my_data.dart';
import '../entities/title_data.dart';

abstract class MyDataRepository {
  Future<List<MyData>> getMyData();
  Future<List<TitleData>> getTitleData();
  Future<bool> setTitle(String id);
}
