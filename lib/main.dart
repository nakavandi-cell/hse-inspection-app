import 'package:flutter/material.dart';

import 'services/seed_loader.dart';

void main() {
  runApp(const HseInspectionApp());
}

class HseInspectionApp extends StatelessWidget {
  const HseInspectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HSE Inspection App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
HomePage extends Stateless: const ChecklistHomePage(),
    );
  }
}

class ChecklistHomePage extends StatelessWidget {
  const ChecklistHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = SeedLoader.categories;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('بازرسی ایمنی و بهداشت'),
          centerTitle: true,
        ),
        body: categories.isEmpty
            ? const Center(
                child: Text('هیچ چک‌لیستی ثبت نشده است.'),
              )
            :هیچ چک‌لیستی ثبت نشده است.'),
              )
            :                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final checklists = SeedLoader.getByCategory(category);

                  return Card(
                    child: ExpansionTile(
                      leading: const Icon(
                        Icons.folder_open,
                        color: Colors.blue,
                      ),
                      title: Text(
                        category,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${checklists.length} چک‌لیست',
                      ),
                      children: checklists
                          .map(
                            (checklist) => ListTile(
                              leading: const Icon(
                                Icons.checklist,
                                color: Colors.green,
                              ),
                              title: Text(checklist.title),
                              subtitle: Text(checklist.code),
                              trailing: const Icon(
                                Icons.arrow_back_ios,
                                size: 16,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChecklistPreviewPage(
                                      checklist: checklist,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class ChecklistPreviewPage extends StatelessWidget {
  final ChecklistItem checklist;

  const ChecklistPreviewPage({
    super.key,
    required this.checklist,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(checklist.title),
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      checklist.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('کد چک‌لیست: ${checklist.code}'),
                    Text('دسته‌بندی: ${checklist.category}'),
                  ],
                ),
              ),
            ),
            ...checklist.sections.asMap().entries.map(
              (entry) {
                final sectionNumber = entry.key + 1;
                final section = entry.value;

                return Card(
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      '$sectionNumber. ${section.title}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: section.questions.asMap().entries.map(
                      (questionEntry) final                        final questionNumber = questionEntry.key + 1;
                        final question = questionEntry.value;

                        return ListTile(
                          leading: CircleAvatar(
                            radius: 14,
                            child: Text(
                              '$questionNumber',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          title: Text(question),
                          trailing: const Icon(
                            Icons.radio_button_unchecked,
                          ),
                        );
                      },
                    ).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
