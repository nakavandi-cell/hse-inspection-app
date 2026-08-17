import 'package:flutter/material.dart';

import 'core/db/app_database.dart';
import 'core/repositories/checklist_repository.dart';
import 'pages/checklist_menu_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Database
  await AppDatabase.instance.database;
  
  // Initialize Data Source
  await ChecklistRepository.instance.initialize();
  
  runApp(const HSEInspectionApp());
}

class HSEInspectionApp extends StatelessWidget {
  const HSEInspectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HSE Inspection',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
      ),
      home: const ChecklistMenuPage(),
    );
  }
}
