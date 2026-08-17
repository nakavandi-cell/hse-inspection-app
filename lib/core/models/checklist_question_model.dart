class ChecklistQuestion {
  final String id;
  final String text;
  final String? checklistId;
  final bool requiredField;
  final String answerType;
  final List<String> options;
  final int order;

  const ChecklistQuestion({
    required this.id,
    required this.text,
    this.checklistId,
    this.requiredField = true,
    this.answerType = 'yes_no',
    this.options = const [],
    this.order = 0,
  });

  factory ChecklistQuestion.fromJson(Map<String, dynamic> json) {
    return ChecklistQuestion(
      id: (json['id'] ?? '').toString(),
      text: (json['text'] ?? json['title'] ?? '').toString(),
      checklistId: json['checklistId']?.toString(),
      requiredField: json['requiredField'] == null
          ? true
          : json['requiredField'] == true || json['requiredField'] == 1,
      answerType: (json['answerType'] ?? 'yes_no').toString(),
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      order: json['order'] is int
          ? json['order'] as int
          : int.tryParse(json['order']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      if (checklistId != null) 'checklistId': checklistId,
      'requiredField': requiredField,
      'answerType': answerType,
      'options': options,
      'order': order,
    };
  }

  ChecklistQuestion copyWith({
    String? id,
    String? text,
    String? checklistId,
    bool? requiredField,
    String? answerType,
    List<String>? options,
    int? order,
  }) {
    return ChecklistQuestion(
      id: id ?? this.id,
      text: text ?? this.text,
      checklistId: checklistId ?? this.checklistId,
      requiredField: requiredField ?? this.requiredField,
      answerType: answerType ?? this.answerType,
      options: options ?? this.options,
      order: order ?? this.order,
    );
  }
}
