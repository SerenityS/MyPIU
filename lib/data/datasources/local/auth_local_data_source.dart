import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:piu_util/domain/entities/login_entity.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final String _key = 'credential';

  Future<void> deleteCredential() async {
    await storage.delete(key: _key);
  }

  Future<LoginEntity?> getCredential() async {
    final credential = await storage.read(key: _key);

    if (credential != null) {
      return LoginEntity.fromJson(jsonDecode(credential));
    } else {
      return null;
    }
  }

  Future<void> saveCredential(LoginEntity credential) async {
    await storage.write(key: _key, value: jsonEncode(credential.toJson()));
  }
}
