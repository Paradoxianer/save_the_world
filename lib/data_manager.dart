import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

/// Abstract interface for storage strategies.
abstract class StorageProvider {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

/// Mobile/Desktop implementation using standard File IO.
class FileStorageProvider implements StorageProvider {
  Future<String> _getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Future<String?> read(String key) async {
    try {
      final path = await _getPath();
      final file = io.File('$path/$key.json');
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
      debugPrint("FileStorageProvider: Error reading $key: $e");
    }
    return null;
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      final path = await _getPath();
      final file = io.File('$path/$key.json');
      await file.writeAsString(value);
    } catch (e) {
      debugPrint("FileStorageProvider: Error writing $key: $e");
    }
  }
}

/// Web & Hybrid implementation using SharedPreferences.
class SharedPrefsStorageProvider implements StorageProvider {
  @override
  Future<String?> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> write(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}

/// The central DataManager that delegates work to the correct provider.
class DataManager {
  late final StorageProvider _provider;

  DataManager() {
    // CRITICAL: We separate the instantiation to avoid compiling File IO code on Web
    if (kIsWeb) {
      _provider = SharedPrefsStorageProvider();
    } else {
      _provider = FileStorageProvider();
    }
  }

  Future<String?> readData(String fileName) {
    return _provider.read(fileName);
  }

  Future<void> writeJson(String fileName, String jsonString) {
    return _provider.write(fileName, jsonString);
  }
}
