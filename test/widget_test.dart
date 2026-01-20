import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gts_mobile/login.dart'; // путь к твоему файлу

void main() {
  testWidgets('LoginScreen shows main elements', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Проверяем наличие заголовка
    expect(find.text('Авторизация'), findsOneWidget);

    // Проверяем наличие полей Email и Пароль
    expect(find.byType(TextField), findsNWidgets(2));

    // Проверяем наличие кнопки "Войти"
    expect(find.text('Войти'), findsOneWidget);
  });
}
