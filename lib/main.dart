import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/electrical/presentation/pages/electrical_menu_page.dart';
import 'features/fire_safety/presentation/pages/fire_menu_page.dart';
import 'features/forklift/presentation/pages/forklift_menu_page.dart';
import 'features/inspections/presentation/pages/dynamic_inspection_page.dart';

/// روتر اصلی برنامه به‌صورت top-level تعریف می‌شود تا
/// با هر بار rebuild ویجت‌ها، دوباره ساخته نشود.
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/electrical',
      builder: (context, state) => const ElectricalMenuPage(),
    ),
    GoRoute(
      path: '/fire',
      builder: (context, state) => const FireMenuPage(),
    ),
    GoRoute(
      path: '/forklift',
      builder: (context, state) => const ForkliftMenuPage(),
    ),
    GoRoute(
      path: '/inspection/:section',
      builder: (context, state) {
        final section = state.pathParameters['section'] ?? '';
        final title = state.uri.queryParameters['title'] ?? 'فرم بازرسی';
        return DynamicInspectionPage(
          sectionKey: section,
          sectionTitle: title,
        );
      },
    ),
  ],
);

void main() {
  runApp(
    const ProviderScope(
      child: HSEInspectionApp(),
    ),
  );
}

class HSEInspectionApp extends StatelessWidget {
  const HSEInspectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'سیستم بازرسی HSE',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [
        Locale('fa', 'IR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
