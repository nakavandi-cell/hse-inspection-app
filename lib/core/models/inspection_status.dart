enum InspectionStatus {
  draft('draft', 'پیشنویس'),
  inProgress('in_progress', 'در حال انجام'),
  completed('completed', 'تکمیل شده');

  final String value;
  final String label;
  const InspectionStatus(this.value, this.label);

  static InspectionStatus fromValue(String v) {
    return InspectionStatus.values.firstWhere(
      (s) => s.value == v,
      orElse: () => InspectionStatus.draft,
    );
  }
}
