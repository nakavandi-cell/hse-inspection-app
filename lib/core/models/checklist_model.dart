class ChecklistModel {
  final String id;
  final String title;
  final String category;
  final String? code;
  final String? version;
  final List<ChecklistQuestionModel> questions;

  ChecklistModel({
    required this.id,
    required this.title,
    required this.category,
    this.code,
    this.version,
    this.questions = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'code': code,
        'version': version,
        'questions': questions.map((e) => e.toJson()).toList(),
      };

  factory ChecklistModel.fromJson(Map<String, dynamic> json) {
    return ChecklistModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      code: json['code'] as String?,
      version: json['version'] as String?,
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((e) => ChecklistQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// برای خواندن از SQLite
  factory ChecklistModel.fromDbRow(Map<String, dynamic> row) {
    return ChecklistModel(
      id: row['id'] as String,
      title: row['title'] as String,
      category: row['category'] as String,
      code: row['code'] as String?,
      version: row['version'] as String?,
      questions: const [],
    );
  }

  ChecklistModel copyWith({
    String? id,
    String? title,
    String? category,
    String? code,
    String? version,
    List<ChecklistQuestionModel>? questions,
  }) {
    return ChecklistModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      code: code ?? this.code,
      version: version ?? this.version,
      questions: questions ?? this.questions,
    );
  }
}
