class EquipmentModel {
  final String id;
  final String name;
  final String category;
  final String? location;
  final bool isActive;

  EquipmentModel({
    required this.id,
    required this.name,
    required this.category,
    this.location,
    required this.isActive,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      location: json['location'] as String?,
      isActive: (json['isActive'] as int?) == 1 || json['isActive'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'location': location,
      'isActive': isActive ? 1 : 0,
    };
  }
}
