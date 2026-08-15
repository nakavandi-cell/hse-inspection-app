import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../core/models/checklist_model.dart';

class SeedLoader {
  static const String _seedPath =
      'assets/seeds/checklist_seed.json';

  static Future<List<ChecklistModel>> loadChecklists() async {
    try {
      final jsonString = await rootBundle.loadString(_seedPath);

      if (jsonString.trim().isEmpty) {
        throw const FormatException(
          'Checklist seed file is empty.',
        );
      }

      final dynamic decoded = jsonDecode(jsonString);

      if (decoded is! List<dynamic>) {
        throw const FormatException(
          'Invalid checklist seed structure. '
          'The JSON root must be a list.',
        );
      }

      final checklists = <ChecklistModel>[];

      for (var index = 0; index < decoded.length; index++) {
        final item = decoded[index];

        if (item is! Map) {
          throw FormatException(
            'Invalid checklist at index $index. '
            'Each item must be a JSON object.',
          );
        }

        try {
          final normalizedItem = Map<String, dynamic>.from(item);
          checklists.add(ChecklistModel.fromJson(normalizedItem));
        } catch (error) {
          throw FormatException(
            'Could not parse checklist at index $index: $error',
          );
        }
      }

      if (checklists.isEmpty) {
        throw const FormatException(
          'No checklists were found in the seed file.',
        );
      }

      return checklists;
    } on FlutterError catch (error, stackTrace) {
      debugPrint(
        'SeedLoader asset error at $_seedPath: $error\n$stackTrace',
      );

      throw SeedLoadException(
        message: 'فایل اولیه چک‌لیست‌ها پیدا نشد یا قابل خواندن نیست.',
        cause: error,
      );
    } on FormatException catch (error, stackTrace) {
      debugPrint(
        'SeedLoader JSON error at $_seedPath: $error\n$stackTrace',
      );

      throw SeedLoadException(
        message: 'ساختار فایل JSON چک‌لیست‌ها معتبر نیست.',
        cause: error,
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Unexpected SeedLoader error: $error\n$stackTrace',
      );

      throw SeedLoadException(
        message: 'خطای غیرمنتظره هنگام بارگذاری چک‌لیست‌ها رخ داد.',
        cause: error,
      );
    }
  }
}

class SeedLoadException implements Exception {
  final String message;
  final Object? cause;

  const SeedLoadException({
    required this.message,
    this.cause,
  });

  @override
  String toString() => message;
}
