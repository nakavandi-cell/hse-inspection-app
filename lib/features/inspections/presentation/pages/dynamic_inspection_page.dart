import 'package:flutter/material.dart';
import '../../../../core/models/inspection_model.dart';
import '../../../../core/db/app_database.dart';

class DynamicInspectionPage extends StatefulWidget {
  final dynamic checklist;
  final String checklistId;
  final String checklistTitle;
  final String checklistCode;
  final InspectionModel? inspection;

  const DynamicInspectionPage({
    super.key,
    this.checklist,
    required this.checklistId,
    required this.checklistTitle,
    required this.checklistCode,
    this.inspection,
  });

  @override
  State<DynamicInspectionPage> createState() => _DynamicInspectionPageState();
}

class _DynamicInspectionPageState extends State<DynamicInspectionPage> {
  final Map<String, String> _answers = {};
  final Map<String, TextEditingController> _controllers = {};
  bool _isSaving = false;

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveInspection() async {
    setState(() => _isSaving = true);
    try {
      if (widget.inspection != null && widget.inspection!.id != null) {
        final updated = widget.inspection!.copyWith(status: 'completed');
        await AppDatabase.instance.updateInspection(updated);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('بازرسی با موفقیت ذخیره و ثبت شد')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در ذخیره‌سازی: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.checklistTitle),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.checklistTitle,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (widget.checklistCode.isNotEmpty)
                      Text(
                        'کد چک‌لیست: ${widget.checklistCode}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'آیتم‌های چک‌لیست آماده ارزیابی و ثبت وضعیت می‌باشند.',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveInspection,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                _isSaving ? 'در حال ثبت...' : 'تکمیل و ثبت نهایی بازرسی',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
