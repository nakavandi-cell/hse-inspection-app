import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/electrical/presentation/pages/electrical_menu_page.dart';
import 'features/fire_safety/presentation/pages/fire_menu_page.dart';
import 'features/forklift/presentation/pages/forklift_menu_page.dart';
import 'features/inspections/presentation/pages/dynamic_inspection_page.dart';
import 'features/inspections/presentation/pages/inspections_list_page.dart';

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
      path: '/inspections',
      builder: (context, state) => const InspectionsListPage(),
    ),
    GoRoute(
      path: '/inspection/:section',
      builder: (context, state) {
        final sectionKey = state.pathParameters['section'] ?? '';
        final title = state.uri.queryParameters['title'] ?? 'بازرسی';
        final inspectionId =
            int.tryParse(state.uri.queryParameters['inspectionId'] ?? '');
        return DynamicInspectionPage(
          sectionKey: sectionKey,
          sectionTitle: title,
          inspectionId: inspectionId,
        );
      },
    ),
  ],
);

void main() {
  runApp(const ProviderScope(child: HseApp()));
}

class HseApp extends StatelessWidget {
  const HseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'بازرسی HSE',
      routerConfig: _router,
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [Locale('fa', 'IR')],
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
    );
  }
}
