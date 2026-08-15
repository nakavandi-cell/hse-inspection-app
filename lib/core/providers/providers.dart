import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';
import '../models/checklist_model.dart';
import '../repositories/checklist_repository.dart';
import '../repositories/inspection_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => AppDatabase.instance,
);

final checklistRepositoryProvider = Provider<ChecklistRepository>(
  (ref) => ChecklistRepository(ref.watch(appDatabaseProvider)),
);

final inspectionRepositoryProvider = Provider<InspectionRepository>(
  (ref) => InspectionRepository(ref.watch(appDatabaseProvider)),
);

final allChecklistsProvider = FutureProvider<List<ChecklistModel>>(
  (ref) => ref.watch(checklistRepositoryProvider).getAll(),
);

final checklistByKeyProvider =
    FutureProvider.family<ChecklistModel?, String>(
  (ref, key) => ref.watch(checklistRepositoryProvider).getByKey(key),
);
