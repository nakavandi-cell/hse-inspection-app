import 'dart:typed_data';
import 'package:excel/excel.dart';
import '../core/models/inspection_model.dart';
import '../core/utils/file_saver_web.dart';

class ExcelExportService {
  static Future<void> exportInspection(InspectionModel inspection) async {
    final excel = Excel.createExcel();
    final defaultSheet = excel.getDefaultSheet();
    if (defaultSheet != null) {
      excel.rename(defaultSheet, 'گزارش بازرسی');
    }
    final Sheet sheet = excel['گزارش بازرسی'];

    // Header styling
    final cellStyleHeader = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    // Meta Data Info
    final dateStr = inspection.createdAt.toIso8601String().split('T').first;
    final titleStr = inspection.checklistTitle ?? inspection.title ?? 'بازرسی';

    sheet.appendRow([TextCellValue('عنوان بازرسی:'), TextCellValue(titleStr)]);
    sheet.appendRow([TextCellValue('دسته‌بندی:'), TextCellValue(inspection.checklistCategory)]);
    sheet.appendRow([TextCellValue('کد بازرسی:'), TextCellValue(inspection.checklistCode ?? inspection.id)]);
    sheet.appendRow([TextCellValue('تاریخ بازرسی:'), TextCellValue(dateStr)]);
    sheet.appendRow([TextCellValue('وضعیت:'), TextCellValue(inspection.status.name)]);
    sheet.appendRow([TextCellValue('')]); // خالی

    // Table Columns
    final headers = [
      TextCellValue('ردیف'),
      TextCellValue('شناسه سوال'),
      TextCellValue('وضعیت پاسخ'),
      TextCellValue('توضیحات / اقدام اصلاحی'),
      TextCellValue('زمان ثبت'),
    ];
    sheet.appendRow(headers);

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 6));
      cell.cellStyle = cellStyleHeader;
    }

    // Rows
    if (inspection.answers.isEmpty) {
      sheet.appendRow([
        TextCellValue('1'),
        TextCellValue('-'),
        TextCellValue('پاسخی ثبت نشده است'),
        TextCellValue('-'),
        TextCellValue('-'),
      ]);
    } else {
      for (int i = 0; i < inspection.answers.length; i++) {
        final ans = inspection.answers[i];
        sheet.appendRow([
          TextCellValue((i + 1).toString()),
          TextCellValue(ans.questionId),
          TextCellValue(ans.status),
          TextCellValue(ans.note),
          TextCellValue(ans.answeredAt),
        ]);
      }
    }

    final bytes = excel.encode();
    if (bytes != null) {
      final safeName = titleStr.replaceAll(RegExp(r'[\\/:*?"<>| ]'), '_');
      final fileName = 'HSE_Report_${safeName}_$dateStr.xlsx';
      await FileSaverWeb.saveAndDownload(Uint8List.fromList(bytes), fileName);
    }
  }
}
