import 'package:get/get.dart';

import '../entities/avatar_data.dart';
import '../repositories/avatar_repository.dart';

class AvatarUseCases {
  final AvatarRepository _repository = Get.find<AvatarRepository>();

  BuyAvatarUseCase get buyAvatar => BuyAvatarUseCase(_repository);
  GetAvatarsUseCase get getAvatars => GetAvatarsUseCase(_repository);
  SetAvatarUseCase get setAvatar => SetAvatarUseCase(_repository);
}

class BuyAvatarUseCase {
  final AvatarRepository _repository;
  BuyAvatarUseCase(this._repository);

  Future<bool> execute(String id) async {
    return await _repository.buyAvatar(id);
  }
}

class GetAvatarsUseCase {
  final AvatarRepository _repository;
  GetAvatarsUseCase(this._repository);

  Future<List<AvatarData>> execute() async {
    return await _repository.getAvatars();
  }
}

class SetAvatarUseCase {
  final AvatarRepository _repository;
  SetAvatarUseCase(this._repository);

  Future<bool> execute(String id) async {
    return await _repository.setAvatar(id);
  }
}
