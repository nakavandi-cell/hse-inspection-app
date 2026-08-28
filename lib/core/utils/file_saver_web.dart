import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FileSaverHelper {
  static Future<void> saveFileWeb(List<int> bytes, String fileName) async {
    try {
      if (kIsWeb) {
        // در محیط وب در صورت نیاز از پکیج‌های وب استفاده می‌شود
        return;
      }

      // در محیط اندروید و iOS
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      }
      directory ??= await getApplicationDocumentsDirectory();

      final String filePath = '${directory.path}/$fileName';
      final File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      // باز کردن خودکار فایل اکسل در گوشی کاربر
      await OpenFile.open(filePath);
    } catch (e) {
      debugPrint('Error saving/opening file: $e');
    }
  }
}
