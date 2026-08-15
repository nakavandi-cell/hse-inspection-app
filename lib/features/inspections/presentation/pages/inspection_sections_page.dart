import 'package:flutter/material.dart';

class InspectionSectionsPage extends StatelessWidget {
  const InspectionSectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بخش‌های بازرسی'),
      ),
      body: const Center(
        child: Text('صفحه بخش‌های بازرسی'),
      ),
    );
  }
}
