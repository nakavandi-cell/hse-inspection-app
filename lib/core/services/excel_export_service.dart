import 'package:excel/excel.dart';

import '../models/answer_model.dart';
import '../models/checklist_model.dart';
import '../models/inspection_model.dart';

class ExcelExportService {
  const ExcelExportService();

  String _answerLabel(String value) {
    switch (value) {
      case 'yes':
        return 'بله';
      case 'no':
        return 'خیر';
      case 'partial':
        return 'تا حدودی';
      case 'na':
        return 'ثبت نشده';
      default:
        return value;
    }
  }

  String _statusLabel(String value) {
    switch (value) {
      case 'draft':
        return 'پیش‌نویس';
      case 'in_progress':
        return 'در حال انجام';
      case 'completed':
        return 'تکمیل‌شده';
      default:
        return value;
    }
  }

  List<int>? buildSummaryReport(List<InspectionModel> inspections) {
    final excel = Excel.createExcel();
    final sheet = excel['فهرست بازرسی‌ها'];

    final headers = [
      'شناسه',
      'عنوان',
      'بخش',
      'وضعیت',
      'زمان شروع',
      'زمان تکمیل',
    ];

    for (var c = 0; c < headers.length; c++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0))
          .value = TextCellValue(headers[c]);
    }

    for (var r = 0; r < inspections.length; r++) {
      final item = inspections[r];
      final row = r + 1;

      final values = [
        '${item.id ?? ''}',
        item.title,
        item.sectionKey,
        _statusLabel(item.status),
        item.startedAt?.toString() ?? '',
        item.completedAt?.toString() ?? '',
      ];

      for (var c = 0; c < values.length; c++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: row))
            .value = TextCellValue(values[c]);
      }
    }

    return excel.encode();
  }

  List<int>? buildInspectionReport({
    required InspectionModel inspection,
    required ChecklistModel checklist,
    required List<AnswerModel> answers,
  }) {
    final excel = Excel.createExcel();
    final sheet = excel['گزارش بازرسی'];

    final infoRows = [
      ['عنوان بازرسی', inspection.title],
      ['شناسه بازرسی', '${inspection.id ?? ''}'],
      ['بخش', inspection.sectionKey],
      ['وضعیت', _statusLabel(inspection.status)],
      [
        'زمان شروع',
        inspection.startedAt?.toString() ?? ''
      ],
      [
        'زمان تکمیل',
        inspection.completedAt?.toString() ?? ''
      ],
      [''],
      ['عنوان چک‌لیست', checklist.title],
      ['کد چک‌لیست', checklist.code],
      ['نسخه', checklist.version],
      [''],
      ['ردیف', 'سؤال', 'پاسخ', 'توضیح', 'اقدام اصلاحی'],
    ];

    for (var r = 0; r < infoRows.length; r++) {
      final row = infoRows[r];
      for (var c = 0; c < row.length; c++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r))
            .value = TextCellValue(row[c]);
      }
    }

    var startRow = infoRows.length;
    for (var i = 0; i < checklist.questions.length; i++) {
      final q = checklist.questions[i];
      final answer = answers.where((a) => a.questionId == q.id).toList();
      final a = answer.isNotEmpty
          ? answer.first
          : AnswerModel(
              inspectionId: inspection.id ?? 0,
              questionId: q.id,
              answer: 'na',
            );

      final values = [
        '${i + 1}',
        q.text,
        _answerLabel(a.answer),
        a.note ?? '',
        a.correctiveAction ?? '',
      ];

      for (var c = 0; c < values.length; c++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: startRow))
            .value = TextCellValue(values[c]);
      }

      startRow++;
    }

    return excel.encode();
  }
}
