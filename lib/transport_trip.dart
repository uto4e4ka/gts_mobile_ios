import 'package:flutter/material.dart';
import 'package:gts_mobile/colors.dart';
import 'package:gts_mobile/dto/work_object.dart';
import 'package:gts_mobile/dto/transport.dart';
import 'package:gts_mobile/dto/transport_trip.dart';
import 'package:gts_mobile/fuel_service.dart';

class TransportTripRecordScreen extends StatefulWidget {
  const TransportTripRecordScreen({super.key});

  @override
  State<TransportTripRecordScreen> createState() =>
      _TransportTripRecordScreenState();
}

class _TransportTripRecordScreenState extends State<TransportTripRecordScreen> {
  final FuelService _service = FuelService();

  late Future<List<WorkObj>> _objectsFuture;
  late Future<List<Transport>> _transportFuture;

  int? _selectedObjectId;
  int? _selectedTransportId;

  final TextEditingController _refuelCtrl = TextEditingController();
  final TextEditingController _distanceCtrl = TextEditingController();
  final TextEditingController _routeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _objectsFuture = _service.fetchObjects();
    _transportFuture = _service.fetchTransport();
  }

  /// ===== компактный индикатор загрузки =====
  Widget _loadingIndicator() {
    return const Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(strokeWidth: 3),
      ),
    );
  }

  /// ===== загрузка ранее внесённых данных =====
  Future<void> _loadInsertedIfExists() async {
    if (_selectedObjectId == null || _selectedTransportId == null) return;
    try {
      final trip = await _service.getInserted(
        _selectedTransportId!,
        _selectedObjectId!,
      );

      setState(() {
        _refuelCtrl.text = trip.refuel.toString();
        _distanceCtrl.text = trip.distance.toString();
        _routeCtrl.text = trip.route;
      });
    } catch (_) {
      setState(() {
        _refuelCtrl.clear();
        _distanceCtrl.clear();
        _routeCtrl.clear();
      });
    }
  }

  /// ===== сохранение данных =====
  Future<void> _saveData() async {
    if (_selectedObjectId == null || _selectedTransportId == null) return;

    final refuel = double.tryParse(_refuelCtrl.text) ?? 0;
    final distance = double.tryParse(_distanceCtrl.text) ?? 0;
    final route = _routeCtrl.text;

    try {
      final success = await _service.insertFuel(
        refuel,
        distance,
        _selectedTransportId!,
        _selectedObjectId!,
        route,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Данные успешно сохранены')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------- Объекты ----------
            SizedBox(
              width: double.infinity,
              child: Card(
                color: isDark ? DarkColors.primary : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: FutureBuilder<List<WorkObj>>(
                    future: _objectsFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return _loadingIndicator();

                      return Wrap(
                        spacing: 6,
                        children: snapshot.data!.map((workObj) {
                          return ChoiceChip(
                            label: Text(workObj.object.name),
                            selected: _selectedObjectId == workObj.id,
                            onSelected: (_) {
                              setState(() {
                                _selectedObjectId = workObj.id;
                              });
                              _loadInsertedIfExists();
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// ---------- Заголовок ----------
            const Text(
              "Выберите транспорт",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            /// ---------- Транспорт ----------
            SizedBox(
              height: 160,
              child: FutureBuilder<List<Transport>>(
                future: _transportFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return _loadingIndicator();

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.map((t) {
                      String path;
                      String mname;
                      String title;

                      if (t.name == "Личное") {
                        path = "assets/ts_granta.png";
                        mname = t.name;
                        title = "Ваш личный транспорт";
                      } else if (t.name == "Аренда") {
                        path = "assets/rent.png";
                        mname = t.name;
                        title = "Т/c взятое в аренду";
                      } else {
                        path = "assets/personal.png";
                        mname = "Организаця";
                        title = t.name;
                      }

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTransportId = t.id;
                          });
                          _loadInsertedIfExists();
                        },
                        child: TransportCard(
                          isDark: isDark,
                          title: mname,
                          subtitle: title,
                          imagePath: path,
                          showCheck: _selectedTransportId == t.id,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// ---------- Форма ----------
            Card(
              color: isDark ? DarkColors.primary : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _numberField(isDark, "Заправка", _refuelCtrl),
                          _numberField(isDark, "Дистанция", _distanceCtrl),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextField(
                        controller: _routeCtrl,
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark
                              ? DarkColors.ground
                              : Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: "Маршрут",
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _saveData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? DarkColors.app
                                : LightColors.app,
                          ),
                          child: const Text(
                            "Сохранить",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberField(
    bool isDark,
    String label,
    TextEditingController controller,
  ) {
    return Column(
      children: [
        Text(label),
        const SizedBox(height: 5),
        SizedBox(
          width: 100,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? DarkColors.ground : Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: "0",
            ),
          ),
        ),
      ],
    );
  }
}

/// ---------- Карточка транспорта ----------
/// ❗️НЕ ИЗМЕНЯЛАСЬ
class TransportCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final String subtitle;
  final bool showCheck;
  final String imagePath;

  const TransportCard({
    super.key,
    required this.isDark,
    required this.title,
    required this.subtitle,
    this.showCheck = false,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: isDark ? DarkColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                if (showCheck)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 120,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
