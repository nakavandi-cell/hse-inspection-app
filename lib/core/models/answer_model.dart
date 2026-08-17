// lib/models/answer_model.dart

class AnswerModel {
  final int? id; // برای دیتابیس (auto-increment)
  final String inspectionId;
  final String questionId;
  final String answerValue;

  AnswerModel({
    this.id,
    required this.inspectionId,
    required this.questionId,
    required this.answerValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'inspection_id': inspectionId,
      'question_id': questionId,
      'answer_value': answerValue,
    };
  }

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'],
      inspectionId: json['inspection_id'],
      questionId: json['question_id'],
      answerValue: json['answer_value'],
    );
  }
}
