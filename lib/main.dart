import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/main_container.dart';

void main() {
  runApp(const MonitorKoperApp());
}

class MonitorKoperApp extends StatefulWidget {
  const MonitorKoperApp({super.key});

  @override
  State<MonitorKoperApp> createState() => _MonitorKoperAppState();
}

class _MonitorKoperAppState extends State<MonitorKoperApp> {
  bool _isLoggedIn = false;

  void _handleLogin() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor Koper CCTV',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: _isLoggedIn 
          ? const MainContainer() 
          : LoginScreen(onLoginSuccess: _handleLogin),
    );
  }
}
