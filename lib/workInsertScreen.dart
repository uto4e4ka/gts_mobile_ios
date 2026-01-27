import 'package:flutter/material.dart';
import 'package:gts_mobile/dto/price_work_response.dart';
import 'package:gts_mobile/dto/today_work_response.dart';
import 'package:gts_mobile/dto/work_category_response.dart';
import 'package:gts_mobile/work_service.dart';
import 'colors.dart';
import 'dto/over_get.dart';

class WorkInsertScreen extends StatefulWidget {
  final int objectId;

  const WorkInsertScreen({super.key, required this.objectId});

  @override
  State<WorkInsertScreen> createState() => _WorkInsertScreenState();
}

class _WorkInsertScreenState extends State<WorkInsertScreen>
    with SingleTickerProviderStateMixin {
  late bool isDark;
  late Future<WorkCategoryResponse> categoriesFuture;
  TabController? _tabController;

  final Map<int, Future<PriceWorksResponse>> priceFutures = {};
  late Future<TodayWorksResponse> workResponse;
  final Map<int, double> workCounts = {};
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    categoriesFuture = WorkService().fetchCategoryWork(1);

    categoriesFuture.then((catResp) {
      _tabController = TabController(
        length: catResp.categories.length,
        vsync: this,
      );

      for (final cat in catResp.categories) {
        priceFutures[cat.id] = WorkService().fetchPriceWork(cat.id);
      }
      setState(() {});
    });

    _loadWorkCounts();
  }

  Future<void> _loadWorkCounts() async {
    workResponse = WorkService().fetchWork(widget.objectId, 1);
    final response = await workResponse;

    workCounts.clear();
    for (final work in response.works) {
      workCounts[work.priceWork.id] = work.nums;
    }
    setState(() {});
  }

  Future<void> _refreshCurrentTab() async {
    final categories = (await categoriesFuture).categories;
    final currentIndex = _tabController?.index ?? 0;
    final currentCategoryId = categories[currentIndex].id;

    setState(() {
      priceFutures[currentCategoryId] = WorkService().fetchPriceWork(
        currentCategoryId,
      );
    });

    await _loadWorkCounts();
  }

  void _showAdditionalInfoDialog() {
    print("Opening Overtime Dialog for object ${widget.objectId}");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          _OvertimeDialog(isDark: isDark, objectId: widget.objectId),
    );
  }

  @override
  Widget build(BuildContext context) {
    isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? DarkColors.ground : LightColors.ground,
      appBar: AppBar(
        title: Text(
          'GTS mobile',
          style: TextStyle(
            color: isDark ? DarkColors.app : LightColors.app,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? DarkColors.secondary : LightColors.secondary,
      ),
      body: FutureBuilder<WorkCategoryResponse>(
        future: categoriesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final categories = snapshot.data!.categories;

          return Column(
            children: [
              Container(
                color: isDark ? DarkColors.primary : LightColors.primary,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: isDark ? DarkColors.app : LightColors.app,
                  indicatorColor: isDark ? DarkColors.app : LightColors.app,
                  tabs: categories.map((c) => Tab(text: c.name)).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? DarkColors.secondary
                              : LightColors.secondary,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Поиск',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) =>
                              setState(() => searchQuery = value.toLowerCase()),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? DarkColors.secondary
                            : LightColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.message,
                          color: isDark ? DarkColors.app : LightColors.app,
                        ),
                        onPressed: _showAdditionalInfoDialog,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: categories
                      .map((c) => _buildTabContent(c.id))
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabContent(int catId) {
    return FutureBuilder<PriceWorksResponse>(
      future: priceFutures[catId],
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final works = snapshot.data!.priceWorks;
        final filteredWorks = works
            .where((w) => w.name.toLowerCase().contains(searchQuery))
            .toList();

        if (filteredWorks.isEmpty)
          return const Center(child: Text('Ничего не найдено'));

        return RefreshIndicator(
          onRefresh: _refreshCurrentTab,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: filteredWorks.length,
            itemBuilder: (context, index) {
              final work = filteredWorks[index];
              final number = workCounts[work.id] ?? 0;

              return WorkCard(
                isDark: isDark,
                title: work.name,
                price: '${work.price} руб/${work.unit.name}',
                hours: work.unit.name,
                number: number.toInt(),
                onAdd: () async {
                  final response = await WorkService().addWork(
                    1,
                    widget.objectId,
                    1,
                    work.id,
                    1,
                  );
                  setState(() => workCounts[work.id] = response.nums);
                },
                onRemove: () async {
                  final response = await WorkService().subWork(
                    1,
                    widget.objectId,
                    1,
                    work.id,
                    1,
                  );
                  setState(() => workCounts[work.id] = response.nums);
                },
                onChanged: (_) {},
                onSubmit: (_) {},
              );
            },
          ),
        );
      },
    );
  }
}

/// =================== OVERTIME DIALOG ===================

class _OvertimeDialog extends StatefulWidget {
  final bool isDark;
  final int objectId;

  const _OvertimeDialog({required this.isDark, required this.objectId});

  @override
  State<_OvertimeDialog> createState() => _OvertimeDialogState();
}

class _OvertimeDialogState extends State<_OvertimeDialog> {
  double hours = 0.0;
  bool isDayOff = false;
  final TextEditingController commentController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOvertime();
  }

  Future<void> _loadOvertime() async {
    print("Loading overtime for object ${widget.objectId}");
    try {
      final overModel = await WorkService().fetchOver(widget.objectId);
      print("OverModel received: $overModel");
      setState(() {
        hours = overModel.over;
        isDayOff = overModel.k != 1;
        commentController.text = overModel.comment ?? '';
        isLoading = false;
      });
    } catch (e) {
      print("Failed to fetch over: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveOvertime() async {
    setState(() => isLoading = true);
    try {
      final k = isDayOff ? 2 : 1;
      print("Saving overtime: hours=$hours, k=$k");
      await WorkService().setOver(
        widget.objectId,
        hours.toDouble(),
        k,
        commentController.text,
      );
      Navigator.pop(context);
    } catch (e) {
      print("Failed to save overtime: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: SizedBox(
            height: 60,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ),
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Переработка:', style: TextStyle(fontSize: 16)),
                ),
                Text(
                  '${hours % 1 == 0 ? hours.toInt() : hours}ч',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Slider(
              min: 0,
              max: 8,
              divisions: 16,
              value: hours,
              onChanged: (v) => setState(() => hours = v),
            ),
            CheckboxListTile(
              value: isDayOff,
              onChanged: (v) => setState(() => isDayOff = v ?? false),
              title: const Text('Выходной'),
            ),
            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Комментарий'),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveOvertime,
                child: const Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =================== WORK CARD ===================

class WorkCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final String price;
  final String hours;
  final int number;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmit;

  const WorkCard({
    super.key,
    required this.isDark,
    required this.title,
    required this.price,
    required this.hours,
    required this.number,
    required this.onAdd,
    required this.onRemove,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: number.toString());

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? DarkColors.primary : LightColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(title), Text(price)],
            ),
          ),
          Row(
            children: [
              if (number > 0)
                InkWell(
                  onTap: onRemove,
                  child: const Icon(Icons.remove, color: Colors.red),
                ),
              SizedBox(
                width: 30,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              Text(hours),
              InkWell(
                onTap: onAdd,
                child: const Icon(Icons.add, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
