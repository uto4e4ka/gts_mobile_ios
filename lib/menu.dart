import 'package:flutter/material.dart';

import 'package:gts_mobile/colors.dart';
import 'package:gts_mobile/dto/fuel_balance.dart';
import 'package:gts_mobile/dto/statistic.dart';
import 'package:gts_mobile/menuService.dart';
import 'package:gts_mobile/dto/work_response.dart';

// ====== твой бар (аналог HorizontalBar Android) ======
class HorizontalSegmentsBar extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;

  const HorizontalSegmentsBar({
    super.key,
    required this.values,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12,
      child: CustomPaint(
        painter: _SegmentsPainter(values, colors),
        size: const Size(double.infinity, 12),
      ),
    );
  }
}

class _SegmentsPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  _SegmentsPainter(this.values, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold(0.0, (a, b) => a + b);
    double startX = 0;

    for (var i = 0; i < values.length; i++) {
      final paint = Paint()..color = colors[i];
      final width = size.width * (values[i] / total);

      final radius = Radius.circular(8);
      RRect rrect;

      if (i == 0) {
        rrect = RRect.fromRectAndCorners(
          Rect.fromLTWH(startX, 0, width, size.height),
          topLeft: radius,
          bottomLeft: radius,
        );
      } else if (i == values.length - 1) {
        rrect = RRect.fromRectAndCorners(
          Rect.fromLTWH(startX, 0, width, size.height),
          topRight: radius,
          bottomRight: radius,
        );
      } else {
        rrect = RRect.fromLTRBR(
          startX,
          0,
          startX + width,
          size.height,
          Radius.zero,
        );
      }

      canvas.drawRRect(rrect, paint);
      startX += width;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ====== карточка истории работы ======
class AdviseCard extends StatelessWidget {
  final List<double> segments;
  final List<Color> colors;
  final mounthTip;
  const AdviseCard({
    super.key,
    required this.segments,
    required this.colors,
    required this.mounthTip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? DarkColors.primary
            : LightColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            height: 110,
            child: Image.asset("assets/work_history.png", fit: BoxFit.contain),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/history'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Заработано",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Сегодня: ${segments[1]}  ₽",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "За месяц: $mounthTip  ₽",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  HorizontalSegmentsBar(values: segments, colors: colors),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LightColors.app,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                      ),
                      child: const Text(
                        "ПОДРОБНЕЕ",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========== ОСНОВНОЙ ЭКРАН (Stateful) ===========
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<StatisticResponse> futureStats;
  late Future<WorkResponse> workResponse;
  late Future<FuelResponse> fuelResponse;

  @override
  void initState() {
    super.initState();
    futureStats = MenuService().fetchStatistics(); // вызов init-логики
    workResponse = MenuService().workResponse();
    fuelResponse = MenuService().fuelResponse();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? DarkColors.primary : LightColors.primary,
        title: Text(
          "GTS mobile",
          style: TextStyle(
            color: isDark ? DarkColors.app : LightColors.app,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: isDark ? DarkColors.ground : LightColors.ground,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            futureStats = MenuService().fetchStatistics();
          });
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<StatisticResponse>(
            future: futureStats,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Visibility(
                    visible: false,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Test Mode',
                            style: TextStyle(
                              color: isDark
                                  ? DarkColors.text
                                  : LightColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Text(
                            'Version: 1.0',
                            style: TextStyle(color: Colors.black),
                          ),
                          Spacer(),
                          Text('Update', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: futureStats,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }

                      if (!snapshot.hasData) {
                        return const Text("No data");
                      }

                      final stats = snapshot.data!;

                      return Column(
                        children: [
                          AdviseCard(
                            segments: [
                              stats.maxDay, // <-- корректный доступ
                              stats.dayTip,
                              stats.avgTip,
                            ],
                            colors: [Colors.blue, Colors.pink, Colors.orange],
                            mounthTip: stats.monthTip,
                          ),
                        ],
                      );
                    },
                  ),

                  // карточка
                  const SizedBox(height: 5),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                        future: fuelResponse,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          }

                          if (!snapshot.hasData) {
                            return const Text("No data");
                          }

                          final stats = snapshot.data!;
                          return Expanded(
                            child: InkWell(
                              child: _buildCard(
                                isDark,
                                title: "Fuel card",
                                description: "Fuel balance: ${stats.count} л",
                                imagePath: 'assets/fuel_card.png',
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/fuel_insert');
                              },
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: 5),
                      FutureBuilder(
                        future: workResponse,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          }

                          if (!snapshot.hasData) {
                            return const Text("No data");
                          }

                          final stats = snapshot.data!;
                          return Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/work_objects');
                              },
                              child: _buildCardWork(
                                isDark,
                                title: "Work",
                                description: "Objects assigned",
                                count: "${stats.count}",
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Visibility(
                    visible: false,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? DarkColors.primary
                            : LightColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              'Menu Item $index',
                              style: TextStyle(
                                color: isDark
                                    ? DarkColors.text
                                    : LightColors.text,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    bool isDark, {
    required String title,
    required String description,
    required String imagePath,
  }) {
    return Container(
      height: 140,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: isDark ? DarkColors.primary : LightColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? DarkColors.text : LightColors.text,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  color: isDark ? DarkColors.text : LightColors.text,
                ),
              ),
            ],
          ),
          Positioned(
            left: 10,
            bottom: 0,
            child: Image.asset(imagePath, width: 75, height: 75),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWork(
    bool isDark, {
    required String title,
    required String description,
    required String count,
  }) {
    return Container(
      height: 140,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: isDark ? DarkColors.primary : LightColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDark ? DarkColors.text : LightColors.text,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            count,
            style: TextStyle(
              color: isDark ? DarkColors.app : LightColors.app,
              fontSize: 35,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            description,
            style: TextStyle(
              color: isDark ? DarkColors.text : LightColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
