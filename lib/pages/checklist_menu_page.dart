// lib/pages/checklist_menu_page.dart

import 'package:flutter/material.dart';
import '../models/checklist_model.dart';
import '../services/seed_loader.dart';
import 'dynamic_inspection_page.dart'; // فرض بر این است که این فایل از قبل موجود است

class ChecklistMenuPage extends StatefulWidget {
  const ChecklistMenuPage({super.key});

  @override
  State<ChecklistMenuPage> createState() => _ChecklistMenuPageState();
}

class _ChecklistMenuPageState extends State<ChecklistMenuPage> {
  late Future<List<Checklist>> _checklistsFuture;

  @override
  void initState() {
    super.initState();
    _checklistsFuture = SeedLoader.loadChecklists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("انتخاب چک‌لیست بازرسی HSE"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Checklist>>(
        future: _checklistsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("خطا در بارگذاری: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("چک‌لیستی یافت نشد."));
          }

          final checklists = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: checklists.length,
            itemBuilder: (context, index) {
              final item = checklists[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.assignment, color: Colors.blueAccent),
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("کد: ${item.code} | نسخه: ${item.version}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // هدایت به صفحه بازرسی و ارسال چک‌لیست انتخاب شده
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DynamicInspectionPage(checklist: item),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
