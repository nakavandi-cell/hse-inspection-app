import 'package:excel/excel.dart';
import '../core/models/inspection_model.dart';
import '../utils/file_saver_helper.dart';

class ExcelExportService {
  static Future<String> exportInspections(List<InspectionModel> inspections) async {
    final excel = Excel.createExcel();
    final sheet = excel['گزارش بازرسی‌های HSE'];
    excel.setDefaultSheet('گزارش بازرسی‌های HSE');

    // سرستون‌های فارسی
    sheet.appendRow([
      TextCellValue('شناسه بازرسی'),
      TextCellValue('عنوان بازرسی'),
      TextCellValue('کد مدرک'),
      TextCellValue('نام چک‌لیست'),
      TextCellValue('شناسه چک‌لیست'),
      TextCellValue('تاریخ بازرسی'),
      TextCellValue('وضعیت'),
    ]);

    // درج سطرهای بازرسی
    for (final item in inspections) {
      sheet.appendRow([
        TextCellValue(item.id?.toString() ?? '-'),
        TextCellValue(item.title),
        TextCellValue(item.checklistCode),
        TextCellValue(item.checklistTitle),
        TextCellValue(item.checklistId),
        TextCellValue(item.date),
        TextCellValue(item.status == 'completed' ? 'تکمیل شده' : 'در جریان'),
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) {
      throw Exception('خطا در تولید فایل اکسل');
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'HSE_Inspections_Report_$timestamp.xlsx';

    return await FileSaverHelper.saveAndOpenFile(bytes, fileName);
  }
}
