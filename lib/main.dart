import 'package:flutter/material.dart';
import 'package:navway_flutter_mobile/screens/login_screen.dart';
import 'package:navway_flutter_mobile/database/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.seedAdmin();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
    home: LoginScreen(),
  );
  }
}
