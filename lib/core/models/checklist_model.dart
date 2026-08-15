import 'checklist_question_model.dart';

class ChecklistModel {
  final String id;
  final String title;
  final String category;
  final String? code;
  final String? version;
  final List<ChecklistQuestionModel> questions;

  const ChecklistModel({
    required this.id,
    required this.title,
    required this.category,
    this.code,
    this.version,
    required this.questions,
  });

  factory ChecklistModel.fromJson(Map<String, dynamic> json) {
    final rawQuestions = json['questions'] as List<dynamic>? ?? const [];
    return ChecklistModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      code: json['code'] as String?,
      version: json['version'] as String?,
      questions: rawQuestions
          .map((q) => ChecklistQuestionModel.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'category': category,
        'code': code,
        'version': version,
      };

  factory ChecklistModel.fromMap(
    Map<String, dynamic> row,
    List<Map<String, dynamic>> questionRows,
  ) {
    return ChecklistModel(
      id: row['id'] as String,
      title: row['title'] as String,
      category: row['category'] as String,
      code: row['code'] as String?,
      version: row['version'] as String?,
      questions: questionRows
          .map((q) => ChecklistQuestionModel.fromMap(q))
          .toList(),
    );
  }
}
