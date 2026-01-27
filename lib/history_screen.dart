import 'package:flutter/material.dart';
import 'package:gts_mobile/bar.dart';
import 'package:gts_mobile/bar_legend.dart';
import 'package:gts_mobile/colors.dart';
import 'package:gts_mobile/dto/history_model.dart';
import 'package:gts_mobile/history_detail.dart';
import 'package:gts_mobile/work_service.dart';

enum HistoryPeriod { week, month, year }

extension HistoryPeriodExtension on HistoryPeriod {
  String get displayName {
    switch (this) {
      case HistoryPeriod.week:
        return "Неделя";
      case HistoryPeriod.month:
        return "Месяц";
      case HistoryPeriod.year:
        return "Год";
    }
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool isLoading = true;
  bool isEmpty = false;
  HistoryPeriod selectedPeriod = HistoryPeriod.month;
  Map<String, Map<String, HistoryItem>> groupedHistory = {};

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => isLoading = true);

    try {
      final historyModel = await WorkService().fetchHistory(
        selectedPeriod.name,
      );

      setState(() {
        groupedHistory = historyModel.history;
        isEmpty = groupedHistory.isEmpty;
        isLoading = false;
      });
    } catch (_) {
      setState(() {
        groupedHistory = {};
        isEmpty = true;
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadHistory();
  }

  /// ===== Dropdown =====
  Widget _buildPeriodDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButton<HistoryPeriod>(
        value: selectedPeriod,
        items: HistoryPeriod.values
            .map((p) => DropdownMenuItem(value: p, child: Text(p.displayName)))
            .toList(),
        onChanged: (value) async {
          if (value != null) {
            setState(() => selectedPeriod = value);
            await _loadHistory();
          }
        },
      ),
    );
  }

  /// ===== History list =====
  List<Widget> _buildHistoryList() {
    final List<Widget> widgets = [];

    final sortedDates = groupedHistory.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    for (final date in sortedDates) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            date,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );

      final items = groupedHistory[date]!;

      items.forEach((_, item) {
        widgets.add(
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      HistoryDetailsPage(date: date, objId: item.objId),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  /// Категории
                  Row(
                    // children: item.categoryWorkList
                    //     .map(
                    //       (_) => Container(
                    //         margin: const EdgeInsets.only(right: 4),
                    //         width: 12,
                    //         height: 12,
                    //         decoration: const BoxDecoration(
                    //           color: Colors.blue,
                    //           shape: BoxShape.circle,
                    //         ),
                    //       ),
                    //     )
                    //     .toList(),
                  ),

                  const SizedBox(width: 8),

                  /// Название объекта
                  Expanded(
                    child: Text(
                      item.objectName,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  /// Сумма
                  Text(
                    "+${item.sum} ₽",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: isDark ? LightColors.ground : DarkColors.ground,
        ),
        title: Text(
          "GTS mobile",
          style: TextStyle(
            color: isDark ? DarkColors.app : LightColors.app,
            fontWeight: FontWeight.bold,
            backgroundColor: isDark
                ? DarkColors.secondary
                : LightColors.secondary,
          ),
        ),
        backgroundColor: isDark ? DarkColors.secondary : LightColors.secondary,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            /// ===== TOP BAR =====
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    color: isDark ? DarkColors.primary : LightColors.primary,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // ⭐ FIX
                      children: const [
                        SizedBox(height: 20),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: HorizontalSegmentsBar(
                            values: [60, 25, 15],
                            colors: [Colors.blue, Colors.pink, Colors.orange],
                          ),
                        ),

                        SizedBox(height: 20),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: BarLegend(
                            color: Colors.blue,
                            text: "Максимум за день",
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: BarLegend(color: Colors.pink, text: "Сегодня"),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: BarLegend(
                            color: Colors.orange,
                            text: "Среднее в день",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: _buildPeriodDropdown()),
          ],
          body: Builder(
            builder: (_) {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (isEmpty) {
                return const Center(child: Text("Нет активности"));
              }
              return ListView(
                padding: const EdgeInsets.only(top: 5),
                children: _buildHistoryList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
