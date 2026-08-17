// lib/models/inspection_model.dart

import 'inspection_status.dart';

class InspectionModel {
  final String id;
  final String title;
  final DateTime date;
  final InspectionStatus status;

  InspectionModel({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'status': status.name,
    };
  }

  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    return InspectionModel(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      status: InspectionStatus.values.firstWhere((e) => e.name == json['status']),
    );
  }
}
