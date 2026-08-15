import 'package:flutter/material.dart';

class FireMenuPage extends StatelessWidget {
  const FireMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = <FireSectionItem>[
      const FireSectionItem(
        title: 'کپسول‌های آتش‌نشانی',
        subtitle: 'بررسی فشار، پلمب، تاریخ شارژ و جانمایی',
        icon: Icons.fire_extinguisher,
      ),
      const FireSectionItem(
        title: 'فایرباکس‌ها',
        subtitle: 'بررسی شیلنگ، نازل، شیر و دسترسی',
        icon: Icons.inventory_2,
      ),
      const FireSectionItem(
        title: 'سیستم اعلام حریق',
        subtitle: 'کنترل تجهیزات و شرایط کلی سیستم',
        icon: Icons.sensors,
      ),
      const FireSectionItem(
        title: 'مسیرهای خروج و تجهیزات اضطراری',
        subtitle: 'بازرسی راه‌های خروج، علائم و آمادگی اضطراری',
        icon: Icons.exit_to_app,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ایمنی حریق'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: sections.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = sections[index];
            return Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.red.withOpacity(0.12),
                  child: Icon(
                    item.icon,
                    color: Colors.red.shade700,
                  ),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    item.subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('بخش "${item.title}" در مرحله بعد متصل می‌شود.'),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class FireSectionItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const FireSectionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
