import '../models/checklist_model.dart';
import '../../services/seed_loader.dart';

class ChecklistRepository {
  ChecklistRepository._();
  static final ChecklistRepository instance = ChecklistRepository._();

  List<Checklist> _checklists = [];

  List<Checklist> get checklists => _checklists;

  Future<void> initialize() async {
    if (_checklists.isEmpty) {
      _checklists = await SeedLoader.loadChecklists();
    }
  }

  List<Checklist> getByCategory(String category) {
    return _checklists.where((c) => c.category == category).toList();
  }

  Checklist? getById(String id) {
    try {
      return _checklists.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
