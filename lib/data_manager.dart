import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DataManager {
  String _localPath;
  File _workingFile;

  Future<String> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> workingFileFor(String fileName) async {
    final path = await getPath();
    return File('$path/' + fileName + '.json');
  }

  Future<String> readData(String fileName) async {
    try {
      final file = await workingFileFor(fileName);
      // Read the file
      String content = await file.readAsString();
      return content;
    } catch (e) {
      // If we encounter an error, return 0
      return null;
    }
  }

  Future<File> writeJson(String fileName, String jsonString) async {
    File file = await workingFileFor(fileName);
    file.delete();
    file = await workingFileFor(fileName);
    // Write the file
    return file.writeAsString(jsonString);
  }
}
