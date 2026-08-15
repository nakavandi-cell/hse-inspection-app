enum AnswerValue {
  ok('OK', 'سالم / قابل قبول'),
  notOk('NG', 'ناقص / نیازمند اقدام'),
  na('NA', 'قابل اعمال نیست');

  final String value;
  final String label;
  const AnswerValue(this.value, this.label);
}

class AnswerModel {
  final int? id;
  final int inspectionId;
  final String questionId;
  final String answer; // ok / ng / na
  final String? comment;
  final String? correctiveAction;
  final String? correctiveOwner;
  final String? dueDate;
  final String? status; // open / done

  AnswerModel({
    this.id,
    required this.inspectionId,
    required this.questionId,
    required this.answer,
    this.comment,
    this.correctiveAction,
    this.correctiveOwner,
    this.dueDate,
    this.status,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'inspection_id': inspectionId,
        'question_id': questionId,
        'answer': answer,
        'comment': comment,
        'corrective_action': correctiveAction,
        'corrective_owner': correctiveOwner,
        'due_date': dueDate,
        'status': status,
      };

  factory AnswerModel.fromMap(Map<String, dynamic> map) => AnswerModel(
        id: map['id'] as int?,
        inspectionId: map['inspection_id'] as int,
        questionId: map['question_id'] as String,
        answer: map['answer'] as String,
        comment: map['comment'] as String?,
        correctiveAction: map['corrective_action'] as String?,
        correctiveOwner: map['corrective_owner'] as String?,
        dueDate: map['due_date'] as String?,
        status: map['status'] as String?,
      );
}
