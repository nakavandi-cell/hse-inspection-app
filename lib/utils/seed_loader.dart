import 'dart:convert';
import 'package:flutter/services.dart';
import '../core/models/checklist_model.dart';

class SeedLoader {
  static Future<List<ChecklistModel>> loadChecklists() async {
    final jsonString = await rootBundle.loadString('assets/seeds/checklist_seed.json');
    final List<dynamic> decoded = jsonDecode(jsonString);

    return decoded
        .map((e) => ChecklistModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
