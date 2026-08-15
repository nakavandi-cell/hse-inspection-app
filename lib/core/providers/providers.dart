import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// لیست چک‌لیست‌ها برای منوی اصلی
final allChecklistsProvider = FutureProvider<List<ChecklistModel>>((ref) {
  return ref.watch(checklistRepositoryProvider).getAllChecklists();
});

// چک‌لیست‌های یک دسته (مثلاً برق، حریق، اماکن)
final checklistsByCategoryProvider =
    FutureProvider.family<List<ChecklistModel>, String>((ref, category) {
  return ref.watch(checklistRepositoryProvider).getByCategory(category);
});

// لیست تجهیزات
final allEquipmentsProvider =
    FutureProvider<List<EquipmentModel>>((ref) {
  return ref.watch(equipmentRepositoryProvider).getAll();
});

// پیش‌نویس‌های بازرسی برای ادامه
final draftInspectionsProvider =
    FutureProvider<List<InspectionModel>>((ref) {
  return ref.watch(inspectionRepositoryProvider).getDraftInspections();
});
