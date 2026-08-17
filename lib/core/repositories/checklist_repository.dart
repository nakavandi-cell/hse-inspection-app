import '../models/checklist_model.dart';
import '../services/seed_loader.dart';

class ChecklistRepository {
  ChecklistRepository._();
  static final ChecklistRepository instance = ChecklistRepository._();

  Future<List<Checklist>> getAllChecklists() async {
    return SeedLoader.loadChecklists();
  }

  Future<List<Checklist>> getChecklistsByCategory(String category) async {
    final all = await SeedLoader.loadChecklists();
    return all.where((item) => item.category == category).toList();
  }
}
