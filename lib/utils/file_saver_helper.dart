import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';

Future<void> saveExcelBytes({
  required List<int> bytes,
  required String fileName,
}) async {
  await FileSaver.instance.saveFile(
    name: fileName,
    bytes: Uint8List.fromList(bytes),
    ext: 'xlsx',
    mimeType: MimeType.xlsx,
  );
}
