import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileSaverHelper {
  FileSaverHelper._();

  static final FileSaverHelper instance = FileSaverHelper._();

  Future<File> copyToDocuments(File sourceFile, {String? fileName}) async {
    final directory = await getApplicationDocumentsDirectory();
    final targetName = fileName ?? sourceFile.path.split(Platform.pathSeparator).last;
    final targetPath = '${directory.path}/$targetName';

    final targetFile = File(targetPath);
    return sourceFile.copy(targetFile.path);
  }

  Future<String> getDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> saveBytesAsFile({
    required List<int> bytes,
    required String fileName,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
