import '../entities/avatar_data.dart';

abstract class AvatarRepository {
  Future<bool> buyAvatar(String id);
  Future<List<AvatarData>> getAvatars();
  Future<bool> setAvatar(String id);
}
