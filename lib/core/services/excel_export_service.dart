import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

import '../models/answer_model.dart';
import '../models/checklist_model.dart';
import '../models/inspection_model.dart';

class ExcelExportService {
  ExcelExportService._();

  static final ExcelExportService instance = ExcelExportService._();

  Future<File> exportInspection({
    required InspectionModel inspection,
    required Checklist checklist,
    required List<AnswerModel> answers,
  }) async {
    final excel = Excel.createExcel();
    final sheetName = 'Inspection';

    final sheet = excel[sheetName];

    // Remove default sheet if present and not needed.
    if (excel.tables.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    final headerStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    final valueStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Left,
      verticalAlign: VerticalAlign.Center,
    );

    int row = 0;

    void writeLabelValue(String label, String value) {
      sheet
          .cell(CellIndex.indexByString('A${row + 1}'))
          .value = TextCellValue(label);
      sheet.cell(CellIndex.indexByString('A${row + 1}')).cellStyle = headerStyle;

      sheet
          .cell(CellIndex.indexByString('B${row + 1}'))
          .value = TextCellValue(value);
      sheet.cell(CellIndex.indexByString('B${row + 1}')).cellStyle = valueStyle;

      row++;
    }

    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('HSE Inspection Report');
    sheet.cell(CellIndex.indexByString('A1')).cellStyle = headerStyle;
    row = 1;

    writeLabelValue('Inspection ID', inspection.id);
    writeLabelValue('Inspection Title', inspection.title);
    writeLabelValue('Inspection Date', inspection.date.toIso8601String());
    writeLabelValue('Inspection Status', inspection.status.toString());
    writeLabelValue('Checklist ID', checklist.id);
    writeLabelValue('Checklist Title', checklist.title);
    writeLabelValue('Checklist Code', checklist.code);
    writeLabelValue('Checklist Version', checklist.version);

    row += 1;

    sheet.cell(CellIndex.indexByString('A${row + 1}')).value =
        TextCellValue('Questions and Answers');
    sheet.cell(CellIndex.indexByString('A${row + 1}')).cellStyle = headerStyle;
    row++;

    sheet.cell(CellIndex.indexByString('A${row + 1}')).value = TextCellValue('Question ID');
    sheet.cell(CellIndex.indexByString('B${row + 1}')).value = TextCellValue('Question Text');
    sheet.cell(CellIndex.indexByString('C${row + 1}')).value = TextCellValue('Answer');
    sheet.cell(CellIndex.indexByString('D${row + 1}')).value = TextCellValue('Required Field');

    sheet.cell(CellIndex.indexByString('A${row + 1}')).cellStyle = headerStyle;
    sheet.cell(CellIndex.indexByString('B${row + 1}')).cellStyle = headerStyle;
    sheet.cell(CellIndex.indexByString('C${row + 1}')).cellStyle = headerStyle;
    sheet.cell(CellIndex.indexByString('D${row + 1}')).cellStyle = headerStyle;

    row++;

    final questionMap = {
      for (final q in checklist.questions) q.id: q,
    };

    for (final answer in answers) {
      final question = questionMap[answer.questionId];
      sheet.cell(CellIndex.indexByString('A${row + 1}')).value =
          TextCellValue(answer.questionId);
      sheet.cell(CellIndex.indexByString('B${row + 1}')).value =
          TextCellValue(question?.text ?? '');
      sheet.cell(CellIndex.indexByString('C${row + 1}')).value =
          TextCellValue(answer.answerValue);
      sheet.cell(CellIndex.indexByString('D${row + 1}')).value =
          TextCellValue(question?.requiredField ?? '');

      row++;
    }

    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'inspection_${inspection.id}.xlsx';
    final filePath = '${directory.path}/$fileName';

    final bytes = excel.encode();
    if (bytes == null) {
      throw StateError('Failed to encode Excel workbook.');
    }

    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    return file;
  }
}
