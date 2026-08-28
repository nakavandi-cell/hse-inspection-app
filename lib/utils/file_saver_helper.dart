import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileSaverHelper {
  static Future<String> saveAndOpenFile(List<int> bytes, String fileName) async {
    try {
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      }
      directory ??= await getApplicationDocumentsDirectory();

      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } catch (e) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    }
  }
}
