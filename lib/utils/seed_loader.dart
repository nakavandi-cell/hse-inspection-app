import 'dart:convert';

import 'package:flutter/services.dart';

import '../core/models/checklist.dart';

class SeedLoader {
  static Future<List<Checklist>> loadChecklists() async {
    try {
      const String assetPath = 'assets/seeds/checklists.json';

      final String jsonString = await rootBundle.loadString(assetPath);
      final dynamic decoded = json.decode(jsonString);

      if (decoded is! List) {
        return <Checklist>[];
      }

      return decoded
          .whereType<Map>()
          .map(
            (item) => Checklist.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } catch (_) {
      return <Checklist>[];
    }
  }
}
