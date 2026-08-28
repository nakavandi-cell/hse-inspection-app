import 'answer_model.dart';

enum InspectionStatus {
  draft,
  inProgress,
  completed,
}

extension InspectionStatusExtension on InspectionStatus {
  String get name {
    switch (this) {
      case InspectionStatus.draft:
        return 'draft';
      case InspectionStatus.inProgress:
        return 'inProgress';
      case InspectionStatus.completed:
        return 'completed';
    }
  }

  static InspectionStatus fromString(String? val) {
    if (val == null) return InspectionStatus.draft;
    final lower = val.toLowerCase();
    if (lower.contains('comp')) return InspectionStatus.completed;
    if (lower.contains('prog')) return InspectionStatus.inProgress;
    return InspectionStatus.draft;
  }
}

class InspectionModel {
  final String id;
  final String? title;
  final String? checklistId;
  final String? checklistTitle;
  final String? checklistCode;
  final String checklistCategory;
  final InspectionStatus status;
  final DateTime createdAt;
  final List<AnswerModel> answers;

  const InspectionModel({
    required this.id,
    this.title,
    this.checklistId,
    this.checklistTitle,
    this.checklistCode,
    this.checklistCategory = 'عمومی',
    this.status = InspectionStatus.draft,
    DateTime? createdAt,
    this.answers = const <AnswerModel>[],
  }) : createdAt = createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  DateTime get date => createdAt;

  factory InspectionModel.fromDbMap(
    Map<String, dynamic> map, {
    List<AnswerModel> answers = const <AnswerModel>[],
  }) {
    DateTime parsedDate = DateTime.now();
    if (map['createdAt'] != null) {
      parsedDate = DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now();
    } else if (map['created_at'] != null) {
      parsedDate = DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now();
    } else if (map['date'] != null) {
      parsedDate = DateTime.tryParse(map['date'].toString()) ?? DateTime.now();
    }

    final rawStatus = map['status'];
    final InspectionStatus st = rawStatus is InspectionStatus
        ? rawStatus
        : InspectionStatusExtension.fromString(rawStatus?.toString());

    return InspectionModel(
      id: (map['id'] ?? '').toString(),
      title: map['title']?.toString(),
      checklistId: (map['checklistId'] ?? map['checklist_id'])?.toString(),
      checklistTitle: (map['checklistTitle'] ?? map['checklist_title'] ?? map['title'] ?? '').toString(),
      checklistCode: (map['checklistCode'] ?? map['checklist_code'])?.toString(),
      checklistCategory: (map['checklistCategory'] ?? map['checklist_category'] ?? 'عمومی').toString(),
      status: st,
      createdAt: parsedDate,
      answers: answers,
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'title': title ?? checklistTitle ?? '',
      'checklistId': checklistId ?? '',
      'checklistTitle': checklistTitle ?? '',
      'checklistCode': checklistCode ?? '',
      'checklistCategory': checklistCategory,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'date': createdAt.toIso8601String(),
    };
  }

  InspectionModel copyWith({
    String? id,
    String? title,
    String? checklistId,
    String? checklistTitle,
    String? checklistCode,
    String? checklistCategory,
    InspectionStatus? status,
    DateTime? createdAt,
    List<AnswerModel>? answers,
  }) {
    return InspectionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      checklistId: checklistId ?? this.checklistId,
      checklistTitle: checklistTitle ?? this.checklistTitle,
      checklistCode: checklistCode ?? this.checklistCode,
      checklistCategory: checklistCategory ?? this.checklistCategory,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      answers: answers ?? this.answers,
    );
  }
}
