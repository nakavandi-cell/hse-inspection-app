enum InspectionStatus {
  draft('draft'),
  inProgress('in_progress'),
  completed('completed');

  const InspectionStatus(this.dbValue);
  final String dbValue;

  static InspectionStatus fromDb(String? value) {
    switch (value) {
      case 'in_progress':
        return InspectionStatus.inProgress;
      case 'completed':
        return InspectionStatus.completed;
      case 'draft':
      default:
        return InspectionStatus.draft;
    }
  }
}
