class AnswerModel {
  final int? id;
  final int inspectionId;
  final String questionId;
  final String answer;
  final String? note;
  final String? correctiveAction;

  const AnswerModel({
    this.id,
    required this.inspectionId,
    required this.questionId,
    required this.answer,
    this.note,
    this.correctiveAction,
  });

  AnswerModel copyWithInspectionId(int newInspectionId) => AnswerModel(
        id: id,
        inspectionId: newInspectionId,
        questionId: questionId,
        answer: answer,
        note: note,
        correctiveAction: correctiveAction,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'inspection_id': inspectionId,
        'question_id': questionId,
        'answer': answer,
        'note': note,
        'corrective_action': correctiveAction,
      };
}
