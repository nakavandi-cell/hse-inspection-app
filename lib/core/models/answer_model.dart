class AnswerModel {
  final String id;
  final String inspectionId;
  final String questionId;
  final String answerValue;
  final String? comment;
  final DateTime? answeredAt;

  const AnswerModel({
    required this.id,
    required this.inspectionId,
    required this.questionId,
    required this.answerValue,
    this.comment,
    this.answeredAt,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: (json['id'] ?? '').toString(),
      inspectionId: (json['inspectionId'] ?? '').toString(),
      questionId: (json['questionId'] ?? '').toString(),
      answerValue: (json['answerValue'] ?? '').toString(),
      comment: json['comment']?.toString(),
      answeredAt: json['answeredAt'] == null
          ? null
          : DateTime.tryParse(json['answeredAt'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inspectionId': inspectionId,
      'questionId': questionId,
      'answerValue': answerValue,
      if (comment != null) 'comment': comment,
      if (answeredAt != null) 'answeredAt': answeredAt!.toIso8601String(),
    };
  }

  AnswerModel copyWith({
    String? id,
    String? inspectionId,
    String? questionId,
    String? answerValue,
    String? comment,
    DateTime? answeredAt,
  }) {
    return AnswerModel(
      id: id ?? this.id,
      inspectionId: inspectionId ?? this.inspectionId,
      questionId: questionId ?? this.questionId,
      answerValue: answerValue ?? this.answerValue,
      comment: comment ?? this.comment,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'inspection_id': inspectionId,
      'question_id': questionId,
      'answer_value': answerValue,
    };
  }

  factory AnswerModel.fromDbMap(Map<String, dynamic> map) {
    return AnswerModel(
      id: (map['id'] ?? '').toString(),
      inspectionId: (map['inspection_id'] ?? '').toString(),
      questionId: (map['question_id'] ?? '').toString(),
      answerValue: (map['answer_value'] ?? '').toString(),
    );
  }
}
