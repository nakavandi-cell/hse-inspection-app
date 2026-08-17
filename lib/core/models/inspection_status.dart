// lib/models/inspection_status.dart

enum InspectionStatus {
  draft,     // پیش‌نویس
  completed, // تکمیل‌شده
  exported   // خروجی گرفته‌شده
}

extension InspectionStatusExtension on InspectionStatus {
  String get name {
    switch (this) {
      case InspectionStatus.draft: return 'draft';
      case InspectionStatus.completed: return 'completed';
      case InspectionStatus.exported: return 'exported';
    }
  }
}
