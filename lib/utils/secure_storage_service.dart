import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Singleton để dùng toàn cục
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static final String keyName = 'email';
  static final String offlineStatus = 'Guest';
  static String currentUser = 'Guest';

  /// ✅ Save a value with a key
  static Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// ✅ Read a value by key
  static Future<String?> read(String key) async {
    bool isExist = await contains(SecureStorageService.keyName);
    return isExist ? await _storage.read(key: key) : offlineStatus;
  }

  static Future<bool> contains(String key) async {
    final all = await _storage.readAll();
    return all.containsKey(key);
  }
}
