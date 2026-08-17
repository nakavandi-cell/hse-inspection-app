import 'package:flutter/material.dart';

import '../core/models/checklist_model.dart';
import '../core/repositories/checklist_repository.dart';
import 'checklist_detail_page.dart';

class ChecklistMenuPage extends StatefulWidget {
  const ChecklistMenuPage({super.key});

  @override
  State<ChecklistMenuPage> createState() => _ChecklistMenuPageState();
}

class _ChecklistMenuPageState extends State<ChecklistMenuPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Checklist> _allChecklists = <Checklist>[];
  List<Checklist> _filteredChecklists = <Checklist>[];

  @override
  void initState() {
    super.initState();
    _loadChecklists();
    _searchController.addListener(_applySearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_applySearch);
    _searchController.dispose();
    super.dispose();
  }

  void _loadChecklists() {
    final List<Checklist> loaded = ChecklistRepository.instance.checklists;

    setState(() {
      _allChecklists = loaded;
      _filteredChecklists = loaded;
    });
  }

  void _applySearch() {
    final String query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredChecklists = _allChecklists;
      });
      return;
    }

    final List<Checklist> results = _allChecklists.where((Checklist checklist) {
      final String id = checklist.id.toLowerCase();
      final String title = checklist.title.toLowerCase();
      final String category = checklist.category.toLowerCase();

      return id.contains(query) ||
          title.contains(query) ||
          category.contains(query);
    }).toList();

    setState(() {
      _filteredChecklists = results;
    });
  }

  Map<String, List<Checklist>> _groupByCategory(List<Checklist> items) {
    final Map<String, List<Checklist>> grouped = <String, List<Checklist>>{};

    for (final Checklist checklist in items) {
      final String key =
          checklist.category.trim().isEmpty ? 'سایر چک‌لیست‌ها' : checklist.category.trim();

      grouped.putIfAbsent(key, () => <Checklist>[]);
      grouped[key]!.add(checklist);
    }

    for (final List<Checklist> groupItems in grouped.values) {
      groupItems.sort((Checklist a, Checklist b) => a.title.compareTo(b.title));
    }

    return Map<String, List<Checklist>>.fromEntries(
      grouped.entries.toList()
        ..sort((MapEntry<String, List<Checklist>> a, MapEntry<String, List<Checklist>> b) {
          return a.key.compareTo(b.key);
        }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Checklist>> grouped = _groupByCategory(_filteredChecklists);

    return Scaffold(
      appBar: AppBar(
        title: const Text('سامانه بازرسی HSE'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          _HeaderSummary(
            totalChecklists: _allChecklists.length,
            filteredChecklists: _filteredChecklists.length,
          ),
          _SearchBar(controller: _searchController),
          Expanded(
            child: _filteredChecklists.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                    itemCount: grouped.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String category = grouped.keys.elementAt(index);
                      final List<Checklist> items = grouped[category]!;

                      return _CategorySection(
                        category: category,
                        items: items,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSummary extends StatelessWidget {
  const _HeaderSummary({
    required this.totalChecklists,
    required this.filteredChecklists,
  });

  final int totalChecklists;
  final int filteredChecklists;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Text(
            'چک‌لیست‌های موجود: $totalChecklists',
            style: theme.textTheme.titleMedium,
          ),
          Text(
            'نتایج نمایش داده‌شده: $filteredChecklists',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'جست‌وجو بر اساس عنوان، کد یا دسته‌بندی',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'پاک کردن',
                  onPressed: controller.clear,
                  icon: const Icon(Icons.close),
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          isDense: true,
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.items,
  });

  final String category;
  final List<Checklist> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0.6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.25),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
        title: Text(
          category,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text('${items.length} چک‌لیست'),
        children: items.map((Checklist checklist) {
          return _ChecklistTile(checklist: checklist);
        }).toList(),
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({required this.checklist});

  final Checklist checklist;

  int _questionCount(Checklist checklist) {
    return checklist.questions.length;
  }

  @override
  Widget build(BuildContext context) {
    final int count = _questionCount(checklist);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      leading: CircleAvatar(
        radius: 18,
        child: Text(
          count.toString(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(
        checklist.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('کد: ${checklist.id} | تعداد سوالات: $count'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<ChecklistDetailPage>(
            builder: (_) => ChecklistDetailPage(checklist: checklist),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'هیچ چک‌لیستی با این عبارت پیدا نشد.',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
