class EquipmentModel {
  final int? id;
  final String code;
  final String name;
  final String category;
  final String location;
  final String? description;
  final String? createdAt;

  EquipmentModel({
    this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.location,
    this.description,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'code': code,
        'name': name,
        'category': category,
        'location': location,
        'description': description,
        'created_at': createdAt,
      };

  factory EquipmentModel.fromMap(Map<String, dynamic> map) => EquipmentModel(
        id: map['id'] as int?,
        code: map['code'] as String,
        name: map['name'] as String,
        category: map['category'] as String,
        location: map['location'] as String,
        description: map['description'] as String?,
        createdAt: map['created_at'] as String?,
      );
}
