class ChecklistQuestionModel {
  final String id;
  final String checklistId;
  final String text;
  final String type;
  final bool requiredField;

  const ChecklistQuestionModel({
    required this.id,
    required this.checklistId,
    required this.text,
    required this.type,
    required this.requiredField,
  });

  factory ChecklistQuestionModel.fromJson(Map<String, dynamic> json) =>
      ChecklistQuestionModel(
        id: json['id'] as String,
        checklistId: json['checklistId'] as String,
        text: json['text'] as String,
        type: json['type'] as String,
        requiredField: json['requiredField'] as bool? ?? true,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'checklist_id': checklistId,
        'text': text,
        'type': type,
        'required_field': requiredField ? 1 : 0,
      };

  factory ChecklistQuestionModel.fromMap(Map<String, dynamic> m) =>
      ChecklistQuestionModel(
        id: m['id'] as String,
        checklistId: m['checklist_id'] as String,
        text: m['text'] as String,
        type: m['type'] as String,
        requiredField: (m['required_field'] as int? ?? 1) == 1,
      );
}
