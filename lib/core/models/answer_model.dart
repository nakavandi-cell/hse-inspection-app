class AnswerModel {
  final String id;
  final String inspectionId;
  final String questionId;
  final String status;
  final String note;
  final String answeredAt;

  const AnswerModel({
    required this.id,
    required this.inspectionId,
    required this.questionId,
    required this.status,
    this.note = '',
    String? answeredAt,
  }) : answeredAt = answeredAt ?? '';

  factory AnswerModel.fromDbMap(Map<String, dynamic> map) {
    return AnswerModel(
      id: (map['id'] ?? '').toString(),
      inspectionId: (map['inspectionId'] ?? map['inspection_id'] ?? '').toString(),
      questionId: (map['questionId'] ?? map['question_id'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      note: (map['note'] ?? '').toString(),
      answeredAt: (map['answeredAt'] ?? map['answered_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'inspectionId': inspectionId,
      'questionId': questionId,
      'status': status,
      'note': note,
      'answeredAt': answeredAt.isNotEmpty ? answeredAt : DateTime.now().toIso8601String(),
    };
  }
}
