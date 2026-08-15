import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/electrical/presentation/pages/electrical_menu_page.dart';
import 'features/fire_safety/presentation/pages/fire_menu_page.dart';
import 'features/forklift/presentation/pages/forklift_menu_page.dart';

void main() {
  runApp(const ProviderScope(child: HSEInspectionApp()));
}

class HSEInspectionApp extends StatelessWidget {
  const HSEInspectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
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
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'HSE Inspection App',
      routerConfig: router,
      locale: const Locale('fa'),
      supportedLocales: const [
        Locale('fa'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      ),
    );
  }
}
