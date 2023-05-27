import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const storage = FlutterSecureStorage();

  static Future<void> writeToKey(String key, String secret) async {
    return storage.write(key: key, value: secret);
  }

  static Future<String?> readFromKey(String key) async {
    return storage.read(key: key);
  }

  static Future<bool> storageContainsKey(String key) async {
    return storage.containsKey(key: key);
  }

  static Future<void> deleteKeyValuePair(String key) async {
    return storage.delete(key: key);
  }

  static Future<void> writeListToKey(
      String key, List<String> secretList) async {
    final stringList = secretList.join(',');

    return storage.write(key: key, value: stringList);
  }

  static Future<List<String>?> readListFromKey(String key) async {
    final stringList = await storage.read(key: key);

    if (stringList != null) {
      return stringList.split(',');
    } else {
      return null;
    }
  }
}
