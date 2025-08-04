import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

void register(String username, String password) async {
  // Store the user's credentials securely
  await storage.write(key: 'username', value: username);
  await storage.write(key: 'password', value: password);

  // Generate a "token" for the user (in this case, a random number)
  String token = Random().nextInt(1000000).toString();

  // Store the token
  await storage.write(key: 'token', value: token);
}

Future<String?> login(String username, String password) async {
  // Retrieve the stored credentials
  String? storedUsername = await storage.read(key: 'username');
  String? storedPassword = await storage.read(key: 'password');

  // If the entered credentials match the stored ones, retrieve and return the token
  if (username == storedUsername && password == storedPassword) {
    String? token = await storage.read(key: 'token');
    return token;
  } else {
    return null;
  }
}

Future<void> logout() async {
  await storage.delete(key: 'token');
}

Future<bool> isLoggedIn() async {
  String? token = await storage.read(key: 'token');
  return token != null;
}
