import 'package:flutter/material.dart';
import 'package:gts_mobile/dto/appointed_object.dart';
import 'package:gts_mobile/work_service.dart';
import 'colors.dart';

class WorkChooseObjectPage extends StatefulWidget {
  const WorkChooseObjectPage({super.key});

  @override
  State<WorkChooseObjectPage> createState() => _WorkChooseObjectPageState();
}

class _WorkChooseObjectPageState extends State<WorkChooseObjectPage>
    with SingleTickerProviderStateMixin {
  List<AppointedObject> _objects = [];
  bool _isLoading = true;
  late bool isDark;

  // Индекс выбранного Tab
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadObjects();
  }

  Future<void> _loadObjects() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final objects = await WorkService().fetchAppointedObjects();
      print(objects);
      setState(() {
        _objects = objects;
      });
    } catch (e) {
      print("Error loading objects: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: isDark ? LightColors.ground : DarkColors.ground,
        ),
        backgroundColor: isDark ? DarkColors.secondary : LightColors.secondary,
        title: Text(
          "GTS mobile",
          style: TextStyle(
            color: isDark ? DarkColors.app : LightColors.app,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: isDark ? DarkColors.ground : LightColors.ground,
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            Container(
              color: isDark ? DarkColors.primary : LightColors.primary,
              child: TabBar(
                isScrollable: true,
                indicatorColor: isDark ? DarkColors.app : LightColors.app,
                labelColor: isDark ? DarkColors.app : LightColors.app,
                onTap: (index) {
                  setState(() {
                    _currentTabIndex = index; // Сохраняем выбранный Tab
                  });
                },
                tabs: const [
                  Tab(text: "Газ"),
                  Tab(text: "Бассейны"),
                  Tab(text: "Продажи"),
                  Tab(text: "Материалы"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(),
                  _buildList(),
                  _buildList(),
                  _buildList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Строим список объектов с RefreshIndicator
  Widget _buildList() {
    return RefreshIndicator(
      onRefresh: _loadObjects,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              itemCount: _objects.length,
              itemBuilder: (context, index) {
                final obj = _objects[index];
                return ObjectCard(
                  isDark: isDark,
                  name: obj.object.workObj.object.name,
                  expireText: "Истекает через:",
                  expireValue: "${obj.daysRemaining} дней",
                  isBind: obj.alreadyInsert,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/insert_work',
                      arguments: {
                        'objectId': obj.object.id,
                        'category': _currentTabIndex + 1, // Передаем индекс Tab
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}

/// ─────────────────────────────────────────────
///              К А Р Т О Ч К А
/// ─────────────────────────────────────────────
class ObjectCard extends StatelessWidget {
  final bool isDark;
  final String name;
  final String expireText;
  final String expireValue;
  final bool isBind;
  final VoidCallback? onTap;

  const ObjectCard({
    super.key,
    required this.isDark,
    required this.name,
    required this.expireText,
    required this.expireValue,
    required this.isBind,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,

        /// Затемнение при клике
        highlightColor: (isDark ? Colors.white : Colors.black).withOpacity(
          0.15,
        ),

        /// Слабый ripple
        splashColor: (isDark ? Colors.white : Colors.black).withOpacity(0.12),

        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? DarkColors.primary : LightColors.primary,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              if (!isDark)
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        color: isDark ? DarkColors.text : LightColors.text,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    expireText,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? DarkColors.text : LightColors.text,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    expireValue,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? DarkColors.positive
                          : LightColors.positive,
                    ),
                  ),
                  const Spacer(),
                  if (isBind)
                    Icon(
                      Icons.done,
                      size: 20,
                      color: isDark ? Colors.white70 : Colors.black45,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
