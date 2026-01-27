import 'package:flutter/material.dart';
import 'package:gts_mobile/colors.dart';
import 'package:gts_mobile/history_detail.dart';
import 'package:gts_mobile/history_screen.dart';
import 'package:gts_mobile/login.dart';
import 'package:gts_mobile/menu.dart';

import 'package:gts_mobile/transport_trip.dart';
import 'package:gts_mobile/workChoose.dart';
import 'package:gts_mobile/workInsertScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Темы (можешь менять цвета)
      theme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: LightColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: DarkColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      themeMode: ThemeMode.light, // Автоматически светлая/темная
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MenuScreen(),
        '/work_objects': (context) => const WorkChooseObjectPage(),
        '/fuel_insert': (context) => const TransportTripRecordScreen(),
        '/history': (context) => const HistoryScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/insert_work') {
          final args = settings.arguments as Map<String, dynamic>;
          final objectId = args['objectId'] as int;
          final category = args['category'] as int;

          return MaterialPageRoute(
            builder: (_) =>
                WorkInsertScreen(objectId: objectId, category: category),
          );
        }
        return null;
      },
    );
  }
}
