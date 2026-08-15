import 'package:flutter/material.dart';

class ForkliftMenuPage extends StatelessWidget {
  const ForkliftMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = <ForkliftSectionItem>[
      const ForkliftSectionItem(
        title: 'بازرسی روزانه لیفتراک',
        subtitle: 'کنترل ظاهری، عملکردی و ایمنی قبل از استفاده',
        icon: Icons.today,
      ),
      const ForkliftSectionItem(
        title: 'کنترل اپراتور و مدارک',
        subtitle: 'صلاحیت، آموزش و مجوزهای مرتبط',
        icon: Icons.badge,
      ),
      const ForkliftSectionItem(
        title: 'وضعیت فنی و تجهیزات ایمنی',
        subtitle: 'چراغ‌ها، بوق، ترمز، لاستیک‌ها و موارد ایمنی',
        icon: Icons.build,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('بازرسی لیفتراک'),
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
                  backgroundColor: Colors.orange.withOpacity(0.15),
                  child: Icon(
                    item.icon,
                    color: Colors.orange.shade800,
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

class ForkliftSectionItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const ForkliftSectionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
