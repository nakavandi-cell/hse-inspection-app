import 'package:flutter/material.dart';

import '../repositories/checklist_repository.dart';
import '../repositories/equipment_repository.dart';
import '../repositories/inspection_repository.dart';

class AppProviders {
  AppProviders._();

  static final checklistRepository = ChecklistRepository.instance;
  static final equipmentRepository = EquipmentRepository.instance;
  static final inspectionRepository = InspectionRepository.instance;
}
