import 'package:flutter/material.dart';

class ElectricalMenuPage extends StatelessWidget {
  const ElectricalMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = <ElectricalSectionItem>[
      const ElectricalSectionItem(
        title: 'برق عمومی',
        subtitle: 'بررسی شرایط عمومی ایمنی برق در محیط',
        icon: Icons.bolt,
      ),
      const ElectricalSectionItem(
        title: 'تابلوهای برق',
        subtitle: 'بازرسی تابلوهای توزیع و حفاظتی',
        icon: Icons.electrical_services,
      ),
      const ElectricalSectionItem(
        title: 'تابلوهای پست برق',
        subtitle: 'بازرسی تابلوها و شرایط ایمنی پست',
        icon: Icons.settings_input_component,
      ),
      const ElectricalSectionItem(
        title: 'وسایل برقی پرتابل',
        subtitle: 'کنترل کابل، دوشاخه، بدنه و ایمنی تجهیزات قابل حمل',
        icon: Icons.power,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('بازرسی برق'),
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
                  backgroundColor: Colors.blue.withOpacity(0.12),
                  child: Icon(
                    item.icon,
                    color: Colors.blue.shade800,
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

class ElectricalSectionItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const ElectricalSectionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
