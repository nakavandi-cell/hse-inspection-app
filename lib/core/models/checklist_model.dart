// lib/models/checklist_model.dart

class Checklist {
  final String id;
  final String title;
  final String category;
  final String code;
  final String version;
  final List<ChecklistQuestion> questions;

  Checklist({
    required this.id,
    required this.title,
    required this.category,
    required this.code,
    required this.version,
    required this.questions,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      code: json['code'] as String,
      version: json['version'] as String,
      questions: (json['questions'] as List)
          .map((q) => ChecklistQuestion.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'code': code,
      'version': version,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class ChecklistQuestion {
  final String id;
  final String checklistId;
  final String text;
  final String type;
  final bool requiredField;

  ChecklistQuestion({
    required this.id,
