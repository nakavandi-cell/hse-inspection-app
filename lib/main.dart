import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: HSEApp()),
  );
}

class HSEApp extends StatelessWidget {
  const HSEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HSE Inspection',
      debugShowCheckedModeBanner: false,
      // تنظیمات فارسی‌سازی و راست‌چین
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [Locale('fa', 'IR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        fontFamily: 'Tahoma', // بعداً فونت حرفه‌ای اضافه می‌کنیم
      ),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سامانه بازرسی HSE'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            _buildMenuCard(context, 'ایمنی حریق', Icons.fire_truck, Colors.red),
            _buildMenuCard(context, 'ایمنی برق', Icons.electric_bolt, Colors.amber),
            _buildMenuCard(context, 'بازرسی اماکن', Icons.factory, Colors.blue),
            _buildMenuCard(context, 'تجهیزات و دارایی‌ها', Icons.inventory, Colors.green),
            _buildMenuCard(context, 'گزارشات و اکسل', Icons.description, Colors.purple),
            _buildMenuCard(context, 'تنظیمات بازرس', Icons.settings, Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          // در مراحل بعد مسیرها را اضافه می‌کنیم
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
