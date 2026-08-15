import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <DashboardMenuItem>[
      const DashboardMenuItem(
        title: 'بازرسی برق',
        subtitle: 'برق عمومی، تابلوها، پست برق و تجهیزات پرتابل',
        route: '/electrical',
        icon: Icons.electrical_services,
        color: Color(0xFF1565C0),
      ),
      const DashboardMenuItem(
        title: 'ایمنی حریق',
        subtitle: 'کپسول‌ها، فایرباکس‌ها و سیستم‌های مرتبط',
        route: '/fire',
        icon: Icons.fire_extinguisher,
        color: Color(0xFFC62828),
      ),
      const DashboardMenuItem(
        title: 'لیفتراک',
        subtitle: 'چک‌لیست‌های بازرسی عملیاتی و ایمنی',
        route: '/forklift',
        icon: Icons.local_shipping,
        color: Color(0xFFEF6C00),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('سیستم بازرسی HSE'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderCard(),
            const SizedBox(height: 16),
            const Text(
              'بخش‌های بازرسی',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.3,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => context.push(item.route),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: item.color.withOpacity(0.12),
                              child: Icon(
                                item.icon,
                                color: item.color,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.subtitle,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_ios, size: 18),
                          ],
                        ),
                      ),
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
}

class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFA726),
            Color(0xFFFB8C00),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اپلیکیشن بازرسی HSE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'ثبت بازرسی، ذخیره نتایج، گزارش‌گیری و توسعه مقیاس‌پذیر برای تجهیزات و بخش‌های مختلف',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardMenuItem {
  final String title;
  final String subtitle;
  final String route;
  final IconData icon;
  final Color color;

  const DashboardMenuItem({
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
    required this.color,
  });
}
