import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tech_fun/models/product_detail.dart';
import 'package:tech_fun/models/user_detail.dart';
import 'package:tech_fun/utils/database_service.dart';

class SecureStorageService {
  // Singleton để dùng toàn cục
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static Map<ProductDetail, int> itemList = {};

  static final String keyName = 'email';
  static final String offlineStatus = 'Guest';
  static String currentUser = 'Guest';
  static UserDetail? user = UserDetail(
    username: 'Guest',
    password: '',
    email: 'Guest@gmail.com',
    phone: '',
    address: '',
    gender: '',
    birth: '',
    CIC: '',
    bankNumber: '',
  );

  /// ✅ Initialize currentUser asynchronously
  static Future<void> init() async {
    currentUser = await read(keyName) ?? offlineStatus;
  }

  /// ✅ Save a value with a key
  static Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
    user = await FirebaseCloundService.getUserByEmail(value);
  }

  /// ✅ Read a value by key
  static Future<String?> read(String key) async {
    bool isExist = await contains(key);
    return isExist ? await _storage.read(key: key) : offlineStatus;
  }

  static Future<bool> contains(String key) async {
    final all = await _storage.readAll();
    return all.containsKey(key);
  }
}
