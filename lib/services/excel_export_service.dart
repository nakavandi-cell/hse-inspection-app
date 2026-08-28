import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import '../core/models/answer_model.dart';
import '../core/models/inspection_model.dart';
import '../core/utils/file_saver_web.dart';

class ExcelExportService {
  static Future<void> exportInspection(InspectionModel inspection) async {
    try {
      final Excel excel = Excel.createExcel();
      const String sheetName = 'گزارش بازرسی';

      // تنظیم شیت پیش‌فرض
      final String defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
      excel.rename(defaultSheet, sheetName);
      final Sheet sheet = excel[sheetName];
      sheet.isRTL = true;

      // ردیف اول: عنوان‌های مشخصات بازرسی
      sheet.appendRow(<CellValue>[
        TextCellValue('شناسه بازرسی'),
        TextCellValue('عنوان چک‌لیست'),
        TextCellValue('دسته‌بندی'),
        TextCellValue('تاریخ ثبت'),
      ]);

      // ردیف دوم: مقادیر مشخصات بازرسی
      sheet.appendRow(<CellValue>[
        TextCellValue(inspection.id),
        TextCellValue(inspection.checklistTitle),
        TextCellValue(inspection.checklistCategory),
        TextCellValue(inspection.createdAt.toIso8601String().split('T').first),
      ]);

      // ایجاد ردیف خالی
      sheet.appendRow(<CellValue>[TextCellValue('')]);
      sheet.appendRow(<CellValue>[TextCellValue('جزئیات پاسخ‌ها:')]);

      // تیتر جدول پاسخ‌ها
      sheet.appendRow(<CellValue>[
        TextCellValue('ردیف'),
        TextCellValue('شناسه سوال'),
        TextCellValue('وضعیت'),
        TextCellValue('توضیحات/اقدام اصلاحی'),
      ]);

      // درج داده‌های پاسخ‌ها
      for (int i = 0; i < inspection.answers.length; i++) {
        final AnswerModel ans = inspection.answers[i];
        sheet.appendRow(<CellValue>[
          TextCellValue((i + 1).toString()),
          TextCellValue(ans.questionId),
          TextCellValue(_translateStatus(ans.status)),
          TextCellValue(ans.note),
        ]);
      }

      // تولید بایت‌ها و ذخیره در گوشی
      final List<int>? fileBytes = excel.save();
      if (fileBytes != null) {
        final String fileName = 'HSE_Report_${inspection.id}.xlsx';
        await FileSaverHelper.saveFileWeb(fileBytes, fileName);
      }
    } catch (e) {
      debugPrint('Export error: $e');
    }
  }

  static String _translateStatus(String status) {
    switch (status) {
      case 'yes':
        return 'بلی';
      case 'no':
        return 'خیر';
      case 'not_applicable':
        return 'نامشمول';
      case 'needs_action':
        return 'نیاز به اقدام';
      default:
        return 'نامشخص';
    }
  }
}
