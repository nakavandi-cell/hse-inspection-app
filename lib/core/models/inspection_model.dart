class InspectionModel {
  final int? id;
  final int equipmentId;
  final String checklistId;
  final String inspectorName;
  final String inspectionDate; // ISO
  final InspectionStatus status;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  InspectionModel({
    this.id,
    required this.equipmentId,
    required this.checklistId,
    required this.inspectorName,
    required this.inspectionDate,
    required this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'equipment_id': equipmentId,
        'checklist_id': checklistId,
        'inspector_name': inspectorName,
        'inspection_date': inspectionDate,
        'status': status.value,
        'notes': notes,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  factory InspectionModel.fromMap(Map<String, dynamic> map) => InspectionModel(
        id: map['id'] as int?,
        equipmentId: map['equipment_id'] as int,
        checklistId: map['checklist_id'] as String,
        inspectorName: map['inspector_name'] as String,
        inspectionDate: map['inspection_date'] as String,
        status: InspectionStatus.fromValue(map['status'] as String),
        notes: map['notes'] as String?,
        createdAt: map['created_at'] as String?,
        updatedAt: map['updated_at'] as String?,
      );

  InspectionModel copyWith({
    int? id,
    int? equipmentId,
    String? checklistId,
    String? inspectorName,
    String? inspectionDate,
    InspectionStatus? status,
    String? notes,
    String? createdAt,
    String? updatedAt,
  }) =>
      InspectionModel(
        id: id ?? this.id,
        equipmentId: equipmentId ?? this.equipmentId,
        checklistId: checklistId ?? this.checklistId,
        inspectorName: inspectorName ?? this.inspectorName,
        inspectionDate: inspectionDate ?? this.inspectionDate,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
