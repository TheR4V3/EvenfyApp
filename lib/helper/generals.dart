import 'dart:io';

import 'package:flutter/foundation.dart';

class Generals {
  static Future<File> writeToFile(Uint8List data) async {
    String tempPath = Directory.systemTemp.path;
    File file = File('$tempPath/temp_image.jpg');
    await file.writeAsBytes(data);
    return file;
  }
}