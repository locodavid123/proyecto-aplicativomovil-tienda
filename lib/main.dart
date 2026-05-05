import 'package:flutter/material.dart';
import 'package:my_app/screens/home_page.dart';
import 'package:my_app/theme/app_theme.dart'; // Asegúrate de que este sea el único origen
import 'package:my_app/services/notificacion_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oliva y Pimienta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomePage(isLoggedIn: false),
    );
  }
}
