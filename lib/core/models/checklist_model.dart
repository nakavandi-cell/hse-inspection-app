import 'checklist_question_model.dart';

class Checklist {
  final String id;
  final String code;
  final String title;
  final String category;
  final String? description;
  final List<ChecklistQuestion> questions;
  final bool isActive;

  const Checklist({
    required this.id,
    required this.code,
    required this.title,
    required this.category,
    this.description,
    this.questions = const [],
    this.isActive = true,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      id: (json['id'] ?? json['checklistId'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      description: json['description']?.toString(),
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => ChecklistQuestion.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList() ??
          const [],
      isActive: json['isActive'] == null
          ? true
          : json['isActive'] == true || json['isActive'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'category': category,
      if (description != null) 'description': description,
      'questions': questions.map((e) => e.toJson()).toList(),
      'isActive': isActive,
    };
  }

  Checklist copyWith({
    String? id,
    String? code,
    String? title,
    String? category,
    String? description,
    List<ChecklistQuestion>? questions,
    bool? isActive,
  }) {
    return Checklist(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      questions: questions ?? this.questions,
      isActive: isActive ?? this.isActive,
    );
  }
}
