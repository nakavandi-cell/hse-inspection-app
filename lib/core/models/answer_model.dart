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
    this.answeredAt = '',
  });

  factory AnswerModel.fromDbMap(Map<String, dynamicماهنگ نیستند.

برای اینکه تمام خطاهای ذکرشده در لاگ با یکبار جایگزینی برای همیشه برطرف شوند و بیلد شما ۱۰۰٪ سبز شود، فایل‌های زیر را در مسیرهای مشخص‌شده در مخزن گیت‌هاب باز کرده و متن کامل آن‌ها را جایگزین کنید:

---

### ۱. فایل مدل پاسخ: `lib/core/models/answer_model.dart`
📌 **مسیر در گیت‌هاب:** `lib/core/models/answer_model.dart`
```dart
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
this.answeredAt = '',
  });

  factory AnswerModel.fromDbMap(Map<String, dynamic> map) {
return AnswerModel(
id: (map['id'] ?? '').toString(),
inspectionId: (map['inspectionId'] ?? map['inspection_id'] ?? '').toString(),
questionId: (map['questionId'] ?? map['question_id'] ?? '').toString(),
status: (map['status'] ?? map['answer_value'] ?? '').toString(),
note: (map['note'] ?? map['comment'] ?? '').toString(),
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
'answeredAt': answeredAt,
};
  }
}
