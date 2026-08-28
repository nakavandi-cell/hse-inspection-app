import 'package:flutter/material.dart';
import '../core/models/inspection_model.dart';
import '../core/db/app_database.dart';
import '../services/excel_export_service.dart';

class InspectionHistoryPage extends StatefulWidget {
  const InspectionHistoryPage({super.key});

  @override
  State<InspectionHistoryPage> createState() => _InspectionHistoryPageState();
}

class _InspectionHistoryPageState extends State<InspectionHistoryPage> {
  late Future<List<InspectionModel>> _inspectionsFuture;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _loadInspections();
  }

  void _loadInspections() {
    setState(() {
      _inspectionsFuture = AppDatabase.instance.getAllInspections();
    });
  }

  Future<void> _exportToExcel(List<InspectionModel> list) async {
    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('هیچ بازرسی ثبت‌شده‌ای برای خروجی اکسل وجود ندارد.')),
      );
      return;
    }

    setState(() => _isExporting = true);
    try {
      final path = await ExcelExportService.exportInspections(list);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فایل اکسل با موفقیت ایجاد و ذخیره شد:\n$path'),
          backgroundColor: Colors.green[700],
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطا در صدور فایل اکسل: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _deleteInspection(int id) async {
    await AppDatabase.instance.deleteInspection(id);
    _loadInspections();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تاریخچه بازرسی‌ها'),
          centerTitle: true,
        ),
        body: FutureBuilder<List<InspectionModel>>(
          future: _inspectionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final list = snapshot.data ?? [];

            if (list.isEmpty) {
              return const Center(
                child: Text(
                  'هنوز بازرسی ثبت نشده است.\nاز صفحه اصلی یک چک‌لیست را انتخاب و بازرسی را شروع کنید.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton.icon(
                    onPressed: _isExporting ? null : () => _exportToExcel(list),
                    icon: _isExporting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.table_chart),
                    label: Text(_isExporting ? 'در حال تهیه خروجی...' : 'دریافت خروجی جامع اکسل'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('کد: ${item.checklistCode} | تاریخ: ${item.date} | وضعیت: ${item.status}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              if (item.id != null) {
                                _deleteInspection(item.id!);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
