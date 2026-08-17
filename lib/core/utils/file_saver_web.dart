import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class FileSaverHelper {
  static void saveFileWeb(List<int> bytes, String fileName) {
    final String base64 = base64Encode(bytes);
    final String anchorAttributes = 'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$base64';
    
    final html.AnchorElement anchor = html.AnchorElement(href: anchorAttributes)
      ..setAttribute('download', fileName)
      ..click();
  }
}
