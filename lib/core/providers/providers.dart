import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/checklist_model.dart';
import '../models/equipment_model.dart';
import '../models/inspection_model.dart';
import '../repositories/checklist_repository.dart';
import '../repositories/equipment_repository.dart';
import '../repositories/inspection_repository.dart';

final checklistRepositoryProvider = Provider<ChecklistRepository>((ref) {
  return ChecklistRepository();
});

final equipmentRepositoryProvider = Provider<EquipmentRepository>((ref) {
  return EquipmentRepository();
});

final inspectionRepositoryProvider = Provider<InspectionRepository>((ref) {
  return InspectionRepository();
});

final allChecklistsProvider = FutureProvider<List<ChecklistModel>>((ref) {
  return ref.watch(checklistRepositoryProvider).getAllChecklists();
});

final checklistsByCategoryProvider =
    FutureProvider.family<List<ChecklistModel>, String>((ref, category) {
  return ref.watch(checklistRepositoryProvider).getByCategory(category);
});

final allEquipmentsProvider = FutureProvider<List<EquipmentModel>>((ref) {
  return ref.watch(equipmentRepositoryProvider).getAll();
});

final draftInspectionsProvider = FutureProvider<List<InspectionModel>>((ref) {
  return ref.watch(inspectionRepositoryProvider).getDraftInspections();
});
