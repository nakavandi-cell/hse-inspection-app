import 'package:excel/excel.dart';

import '../models/answer_model.dart';
import '../models/checklist_model.dart';
import '../models/inspection_model.dart';

String _answerLabel(String v) {
  switch (v) {
    case 'yes':
      return 'بله';
    case 'no':
      return 'خیر';
    case 'partial':
      return 'تا حدودی';
    case 'na':
      return 'بررسی نشده';
    default:
      return v;
  }
}

String _statusLabel(String s) {
  switch (s) {
    case 'draft':
      return 'پیش‌نویس';
    case 'in_progress':
      return 'در حال انجام';
    case 'completed':
      return 'تکمیل‌شده';
    default:
      return s;
  }
}

class ExcelExportService {
  const ExcelExportService();

  /// گزارش کامل یک بازرسی (به‌همراه همه سؤال‌ها و پاسخ‌ها)
  List<int>? buildInspectionReport({
    required InspectionModel inspection,
    required ChecklistModel checklist,
    required List<AnswerModel> answers,
  }) {
    final excel = Excel.createExcel();
    final sheet = excel['بازرسی'];

    final header = [
      ['عنوان', inspection.title],
      ['کد بازرسی', '${inspection.id ?? '-'}'],
      [
        'تاریخ ثبت',
        inspection.completedAt?.toString() ??
            inspection.startedAt?.toString() ??
            '-'
      ],
      ['وضعیت', _statusLabel(inspection.status)],
      [''],
      ['ردیف', 'شرح سؤال', 'پاسخ', 'توضیحات', 'اقدام اصلاحی'],
    ];

    for (var i = 0; i < header.length; i++) {
      for (var j = 0; j < header[i].length; j++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i))
            .value = TextCellValue(header[i][j]?.toString() ?? '');
      }
    }

    var row = header.length;
    var rowNum = 0;
    for (final q in checklist.questions) {
      final a = answers.firstWhere(
        (x) => x.questionId == q.id,
        orElse: () => AnswerModel(
          inspectionId: 0,
          questionId: q.id,
          answer: 'na',
        ),
      );
      final values = [
        '${++rowNum}',
        q.text,
        _answerLabel(a.answer),
        a.note ?? '',
        a.correctiveAction ?? '',
      ];
      for (var j = 0; j < values.length; j++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: row))
            .value = TextCellValue(values[j]);
      }
      row++;
    }

    return excel.encode();
  }

  /// فهرست خلاصه همه بازرسی‌ها
  List<int>? buildSummaryReport(List<InspectionModel> inspections) {
    final excel = Excel.createExcel();
    final sheet = excel['فهرست بازرسی‌ها'];

    const headers = ['کد', 'عنوان', 'وضعیت', 'زمان شروع', 'زمان تکمیل'];
    for (var j = 0; j < headers.length; j++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: 0))
          .value = TextCellValue(headers[j]);
    }

    var row = 1;
    for (final it in inspections) {
      final values = [
        '${it.id ?? '-'}',
        it.title,
        _statusLabel(it.status),
        it.startedAt?.toString() ?? '',
        it.completedAt?.toString() ?? '',
      ];
      for (var j = 0; j < values.length; j++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: row))
            .value = TextCellValue(values[j]);
      }
      row++;
    }

    return excel.encode();
  }
}
