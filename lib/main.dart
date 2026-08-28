import 'package:flutter/material.dart';
import 'services/seed_loader.dart';
import 'pages/checklist_detail_page.dart';
import 'pages/inspection_history_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HSEInspectionApp());
}

class HSEInspectionApp extends StatelessWidget {
  const HSEInspectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سامانه بازرسی HSE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00695C),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'همه';

  @override
  Widget build(BuildContext context) {
    final categories = ['همه', ...SeedLoader.categories];
    final displayedChecklists = _selectedCategory == 'همه'
        ? SeedLoader.allChecklists
        : SeedLoader.getByCategory(_selectedCategory);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('چک‌لیست‌های بازرسی HSE'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'تاریخچه بازرسی‌ها',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InspectionHistoryPage()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: const Color(0xFF80CBC4),
                        onSelected: (val) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: displayedChecklists.length,
                itemBuilder: (context, index) {
                  final item = displayedChecklists[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFFE0F2F1),
                        child: Icon(_getIconForCategory(item.category), color: const Color(0xFF00695C)),
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('کد: ${item.code} | رسته: ${item.category}'),
                          Text('تعداد بخش‌ها: ${item.sections.length} | سوالات: ${item.sections.fold<int>(0, (sum, sec) => sum + sec.questions.length)} مورد'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChecklistDetailPage(
                              checklist: item,
                              checklistId: item.id,
                              category: item.category,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    if (category.contains('برق')) return Icons.bolt;
    if (category.contains('حریق')) return Icons.local_fire_department;
    if (category.contains('ماشین') || category.contains('تجهیزات')) return Icons.precision_manufacturing;
    if (category.contains('بهداشت')) return Icons.restaurant;
    return Icons.assignment;
  }
}
