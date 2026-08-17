import 'package:excel/excel.dart';
import '../core/models/inspection_model.dart';
import '../core/models/answer_model.dart';
import '../core/utils/file_saver_web.dart';

class ExcelExportService {
  static void exportInspection(InspectionModel inspection) {
    final Excel excel = Excel.createExcel();
    final String sheetName = 'گزارش بازرسی';
    
    // حذف شیت پیش‌فرض و ایجاد شیت جدید
    excel.rename(excel.getDefaultSheet()!, sheetName);
    final Sheet sheet = excel[sheetName];

    // استایل تیترها
    final CellStyle headerStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      backgroundColorHex: ExcelColor.blueGrey100,
      fontFamily: getFontFamily(FontFamily.Arial),
    );

    // ردیف اول: اطلاعات کلی بازرسی
    sheet.appendRow(<TextCellValue>[
      const TextCellValue('شناسه بازرسی'),
      const TextCellValue('عنوان چک‌لیست'),
      const TextCellValue('دسته‌بندی'),
      const TextCellValue('تاریخ ثبت'),
    ]);

    sheet.appendRow(<TextCellValue>[
      TextCellValue(inspection.id),
      TextCellValue(inspection.checklistTitle),
      TextCellValue(inspection.checklistCategory),
      TextCellValue(inspection.createdAt.toIso8601String().split('T').first),
    ]);

    // ایجاد فاصله
    sheet.appendRow(<TextCellValue>[]);
    sheet.appendRow(<TextCellValue>[const TextCellValue('جزئیات پاسخ‌ها:')]);

    // تیتر جدول پاسخ‌ها
    sheet.appendRow(<TextCellValue>[
      const TextCellValue('ردیف'),
      const TextCellValue('شناسه سوال'),
      const TextCellValue('وضعیت'),
      const TextCellValue('توضیحات/اقدام اصلاحی'),
    ]);

    // درج داده‌های پاسخ‌ها
    for (int i = 0; i < inspection.answers.length; i++) {
      final AnswerModel ans = inspection.answers[i];
      sheet.appendRow(<TextCellValue>[
        TextCellValue((i + 1).toString()),
        TextCellValue(ans.questionId),
        TextCellValue(_translateStatus(ans.status)),
        TextCellValue(ans.note),
      ]);
    }

    // تولید بایت‌ها و دانلود
    final List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      final String fileName = 'HSE_Report_${inspection.id}.xlsx';
      FileSaverHelper.saveFileWeb(fileBytes, fileName);
    }
  }

  static String _translateStatus(String status) {
    switch (status) {
      case 'yes': return 'بلی';
      case 'no': return 'خیر';
      case 'not_applicable': return 'نامشمول';
      case 'needs_action': return 'نیاز به اقدام';
      default: return 'نامشخص';
    }
  }
}
