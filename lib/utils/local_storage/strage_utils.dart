import 'package:get_storage/get_storage.dart';

class ILocalStorage {
  // Singleton instance
  static final ILocalStorage _instance = ILocalStorage._internal();

  // Factory constructor returns the same instance
  factory ILocalStorage() {
    return _instance;
  }

  // Private constructor
  ILocalStorage._internal();

  // Instance of GetStorage
  final GetStorage _storage = GetStorage();

  // Save data of any type
  Future<void> saveData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  // Read data of generic type
  T? readData<T>(String key) {
    return _storage.read<T>(key);
  }

  // Remove data with given key
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Clear all data in storage
  Future<void> clearAll() async {
    await _storage.erase();
  }
}
