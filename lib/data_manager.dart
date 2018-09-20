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

  Future<File> workingFileFor(int stage) async {
    final path = await getPath();
    return File('$path/$stage.list.json');
  }

  Future<String> readList(int stage) async {
    try {
      final file = await workingFileFor(0);
      // Read the file
      String content = await file.readAsString();
      return content;
    } catch (e) {
      // If we encounter an error, return 0
      return null;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await workingFileFor(0);
    // Write the file
    return file.writeAsString('$counter');
  }
}
