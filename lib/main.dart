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
      ),
      home: const ChecklistHomePage(),
    );
  }
}

class ChecklistHomePage extends StatelessWidget {
  const ChecklistHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = SeedLoader.categories;

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
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  final String category = categories[index];
                  final List<ChecklistItem> checklists =
                      SeedLoader.getByCategory(category);

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
                          .map<Widget>((ChecklistItem checklist) {
                        return ListTile(
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
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                                  return ChecklistPreviewPage(
                                    checklist: checklist,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }).toList(),
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
    final List<Widget> sectionWidgets = <Widget>[];

    for (int sectionIndex = 0;
        sectionIndex < checklist.sections.length;
        sectionIndex++) {
      final ChecklistSection section = checklist.sections[sectionIndex];
      final List<Widget> questionWidgets = <Widget>[];

      for (int questionIndex = 0;
          questionIndex < section.questions.length;
          questionIndex++) {
        final String question = section.questions[questionIndex];

        questionWidgets.add(
          ListTile(
            leading: CircleAvatar(
              radius: 14,
              child: Text(
                '${questionIndex + 1}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            title: Text(question),
            trailing: const Icon(
              Icons.radio_button_unchecked,
            ),
          ),
        );
      }

      sectionWidgets.add(
        Card(
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              '${sectionIndex + 1}. ${section.title}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: questionWidgets,
          ),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(checklist.title),
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      checklist.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'کد چک‌لیست: ${checklist.code}',
                    ),
                    Text(
                      'دسته‌بندی: ${checklist.category}',
                    ),
                  ],
                ),
              ),
            ),
            ...sectionWidgets,
          ],
        ),
      ),
    );
  }
}
