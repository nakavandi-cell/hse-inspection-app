import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../core/models/checklist_model.dart';

class SeedLoader {
  SeedLoader._();

  static Future<List<Checklist>> loadChecklists() async {
    try {
      final String response = await rootBundle.loadString('assets/seeds/checklist_seed.json');
      final Map<String, dynamic> data = json.decode(response);
      
      final List<dynamic> checklistsJson = data['checklists'];
      
      return checklistsJson.map((json) => Checklist.fromJson(json)).toList();
    } catch (e) {
      // در محیط واقعی، خطا را لاگ کنید
      return [];
    }
  }
}
