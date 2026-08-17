// lib/services/seed_loader.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/checklist_model.dart';

class SeedLoader {
  static Future<List<Checklist>> loadChecklists() async {
    try {
      // 1. بارگذاری فایل JSON از مسیر asset تعریف شده
      final String response = await rootBundle.loadString('assets/seeds/checklist_seed.json');
      
      // 2. تبدیل رشته JSON به لیست داینامیک
      final List<dynamic> data = json.decode(response);
      
      // 3. تبدیل لیست داینامیک به لیست مدل Checklist
      return data.map((json) => Checklist.fromJson(json)).toList();
    } catch (e) {
      print("Error loading checklist seed: $e");
      return [];
    }
  }
}
