import 'package:flutter/material.dart';
import 'package:gts_mobile/colors.dart';
import 'package:gts_mobile/dto/history_details.dart';

import 'package:gts_mobile/work_service.dart';

class HistoryDetailsPage extends StatefulWidget {
  final String date;
  final int objId;

  const HistoryDetailsPage({
    super.key,
    required this.date,
    required this.objId,
  });

  @override
  State<HistoryDetailsPage> createState() => _HistoryDetailsPageState();
}

class _HistoryDetailsPageState extends State<HistoryDetailsPage> {
  late Future<HistoryDetails> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<HistoryDetails> _load() {
    return WorkService().fetchHistoryDetils(widget.date, widget.objId);
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _load();
    });
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
          ),
        ),
        backgroundColor: isDark ? DarkColors.primary : LightColors.primary,
      ),
      backgroundColor: isDark ? DarkColors.ground : LightColors.ground,
      body: FutureBuilder<HistoryDetails>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ошибка загрузки\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final data = snapshot.data!;
          return _buildContent(data);
        },
      ),
    );
  }

  Widget _buildContent(HistoryDetails data) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final obj = data.works.first.obj;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            const SizedBox(height: 100),

            /// ===== HEADER =====
            Column(
              children: [
                Image.asset(
                  'assets/histpng.png',
                  width: 50,
                  height: 50,
                  color: LightColors.app,
                ),
                const SizedBox(height: 5),
                Text(
                  obj.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.date, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text(
                  '${data.total.toStringAsFixed(0)} ₽',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: data.compare > 0
                        ? isDark
                              ? DarkColors.positive
                              : LightColors.positive
                        : isDark
                        ? DarkColors.orange
                        : LightColors.orange,
                  ),
                ),
                Text(
                  data.compare > 0
                      ? 'Выше среднего'
                      : data.compare < 0
                      ? 'Ниже среднего'
                      : 'Среднее',
                  style: TextStyle(
                    color: data.compare > 0
                        ? isDark
                              ? DarkColors.positive
                              : LightColors.positive
                        : isDark
                        ? DarkColors.orange
                        : LightColors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 80),

            /// ===== EXTRA =====
            _card(
              title: 'Дополнительно',
              child: Column(
                children: [
                  _row(
                    'Переработка: ${data.hover.toStringAsFixed(0)} ч',
                    '+${data.rover.toStringAsFixed(0)} ₽',
                  ),
                  _row('Коэффициент: ${data.k}', '${data.kValue} ₽'),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// ===== WORK LIST =====
            _card(
              title: 'Список работ',
              child: Column(
                children: data.works.map((work) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(work.priceWork.name),
                        subtitle: Text(
                          '${work.nums} ${work.priceWork.unit.name} x ${work.priceWork.price} ₽',
                        ),
                        trailing: Text(
                          '${work.priceWork.price.toStringAsFixed(0)} ₽',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? DarkColors.primary : LightColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🔥 КЛЮЧЕВО
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? DarkColors.positive : LightColors.positive,
            ),
          ),
        ],
      ),
    );
  }
}
