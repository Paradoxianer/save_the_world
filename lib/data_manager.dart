import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Conditional imports to avoid compilation errors on Web/Mobile
import 'dart:io' if (dart.library.html) 'dart:html' as io_or_html;
import 'package:path_provider/path_provider.dart';

/// Abstract interface for storage strategies.
/// This allows us to switch between File, SharedPreferences, and later Firebase
/// without changing the game logic.
abstract class StorageProvider {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

/// Mobile/Desktop implementation using standard File IO.
/// This remains our primary method for mobile to keep existing saves.
class FileStorageProvider implements StorageProvider {
  Future<String> _getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Future<String?> read(String key) async {
    if (kIsWeb) return null; // Safety check
    try {
      final path = await _getPath();
      final file = io_or_html.File('$path/$key.json');
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
    if (kIsWeb) return; // Safety check
    try {
      final path = await _getPath();
      final file = io_or_html.File('$path/$key.json');
      await file.writeAsString(value);
    } catch (e) {
      debugPrint("FileStorageProvider: Error writing $key: $e");
    }
  }
}

/// Web & Hybrid implementation using SharedPreferences.
/// This is the bridge for Web support and future Firebase syncing.
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
    // Strategy selection: Use SharedPreferences for Web.
    // We could also use it for Mobile as a migration step, 
    // but for now we keep File IO to preserve existing user data.
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
