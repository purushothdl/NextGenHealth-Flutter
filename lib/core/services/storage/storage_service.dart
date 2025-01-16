// lib/core/services/storage/storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token'); // Fixed key
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'access_token'); // Fixed key
  }
}