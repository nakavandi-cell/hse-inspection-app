class ChecklistQuestionModel {
  final String id;
  final String checklistId;
  final String text;
  final String type; // yesno / text / number / select
  final bool requiredField;

  ChecklistQuestionModel({
    required this.id,
    required this.checklistId,
    required this.text,
    required this.type,
    required this.requiredField,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'checklistId': checklistId,
        'text': text,
        'type': type,
        'requiredField': requiredField,
      };

  factory ChecklistQuestionModel.fromJson(Map<String, dynamic> json) {
    return ChecklistQuestionModel(
      id: json['id'] as String,
      checklistId: json['checklistId'] as String? ?? '',
      text: json['text'] as String,
      type: json['type'] as String,
      requiredField: json['requiredField'] as bool? ?? false,
    );
  }
}
