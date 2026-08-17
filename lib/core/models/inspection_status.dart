enum InspectionStatus {
  draft,
  completed,
  synced,
  cancelled,
}

extension InspectionStatusX on InspectionStatus {
  String get value {
    switch (this) {
      case InspectionStatus.draft:
        return 'draft';
      case InspectionStatus.completed:
        return 'completed';
      case InspectionStatus.synced:
        return 'synced';
      case InspectionStatus.cancelled:
        return 'cancelled';
    }
  }

  String get label {
    switch (this) {
      case InspectionStatus.draft:
        return 'پیش‌نویس';
      case InspectionStatus.completed:
        return 'تکمیل‌شده';
      case InspectionStatus.synced:
        return 'همگام‌شده';
      case InspectionStatus.cancelled:
        return 'لغوشده';
    }
  }

  static InspectionStatus fromValue(String? value) {
    switch (value) {
      case 'completed':
        return InspectionStatus.completed;
      case 'synced':
        return InspectionStatus.synced;
      case 'cancelled':
        return InspectionStatus.cancelled;
      case 'draft':
      default:
        return InspectionStatus.draft;
    }
  }
}
