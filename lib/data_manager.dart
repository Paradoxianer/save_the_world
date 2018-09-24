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

  Future<File> workingFileFor(String name) async {
    final path = await getPath();
    return File('$path/' + name + '.json');
  }

  Future<String> readData(String name) async {
    try {
      final file = await workingFileFor(name);
      // Read the file
      String content = await file.readAsString();
      return content;
    } catch (e) {
      // If we encounter an error, return 0
      return null;
    }
  }

  Future<File> writeList(String file, String jsonString) async {
    final file = await workingFileFor(0);
    // Write the file
    return file.writeAsString(jsonString);
  }
}
