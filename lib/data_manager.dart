import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DataManager {
  Future<String> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> workingFileFor(String fileName) async {
    final path = await getPath();
    return File('$path/$fileName.json');
  }

  Future<String?> readData(String fileName) async {
    try {
      final file = await workingFileFor(fileName);
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      // If we encounter an error, return null
      return null;
    }
  }

  Future<File> writeJson(String fileName, String jsonString) async {
    final file = await workingFileFor(fileName);
    // Write the file
    return file.writeAsString(jsonString, mode: FileMode.write);
  }
}
