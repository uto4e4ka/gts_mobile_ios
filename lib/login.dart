import 'package:flutter/material.dart';
import 'package:gts_mobile/authService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'colors.dart';
import 'authService.dart'; // подключаем ваш сервис авторизации

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;
  bool remember = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadRemember();
    _autoLogin();
  }

  Future<void> _loadRemember() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      remember = prefs.getBool('rememberMe') ?? false;
    });
  }

  // Автоматический вход, если токен есть
  Future<void> _autoLogin() async {
    setState(() {
      _isLoading = true;
    });

    String? token = await AuthService.getAccessToken();
    print("Token: ${token ?? "null"}");
    setState(() {
      _isLoading = false;
    });

    if (token != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool success = await AuthService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Переход на главный экран
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = 'Неверный логин или пароль';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? DarkColors.ground : LightColors.ground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Войдите \nв аккаунт \nGTS mobile',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: isDark ? DarkColors.text : LightColors.text,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? DarkColors.secondary : LightColors.secondary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: isDark ? DarkColors.error : LightColors.error,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  // Email
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark
                          ? DarkColors.secondary
                          : LightColors.secondary,
                      hintText: 'Логин',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Password
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark
                          ? DarkColors.secondary
                          : LightColors.secondary,
                      hintText: 'Пароль',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Remember checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: remember,
                        onChanged: (value) async {
                          setState(() {
                            remember = value ?? false;
                          });
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('rememberMe', remember);
                        },
                        side: BorderSide(
                          color: isDark ? DarkColors.app : LightColors.app,
                          width: 2,
                        ),
                        fillColor: MaterialStateProperty.resolveWith<Color>((
                          states,
                        ) {
                          if (states.contains(MaterialState.selected)) {
                            return isDark ? DarkColors.app : LightColors.app;
                          }
                          return Colors.transparent;
                        }),
                      ),
                      Text(
                        'Запомнить меня',
                        style: TextStyle(
                          color: isDark ? DarkColors.text : LightColors.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Login button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? DarkColors.app
                          : LightColors.app,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Войти',
                            style: TextStyle(
                              color: isDark
                                  ? DarkColors.text
                                  : LightColors.text,
                            ),
                          ),
                  ),
                  const SizedBox(height: 30),
                  // Lines + Other services text
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: isDark ? DarkColors.text : LightColors.text,
                          margin: const EdgeInsets.only(right: 10),
                        ),
                      ),
                      Text(
                        'Другие сервисы',
                        style: TextStyle(
                          color: isDark ? DarkColors.text : LightColors.text,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: isDark ? DarkColors.text : LightColors.text,
                          margin: const EdgeInsets.only(left: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Telegram icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/telegram.png', width: 50, height: 50),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
