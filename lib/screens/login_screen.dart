import 'package:flutter/material.dart';
import 'package:navway_flutter_mobile/database/app_database.dart';
import 'package:navway_flutter_mobile/screens/driver_home_screen.dart';
import 'package:navway_flutter_mobile/screens/manager_home_screen.dart';
import 'package:navway_flutter_mobile/screens/student_home_screen.dart';
import 'package:navway_flutter_mobile/models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }
    final db = AppDatabase();
    final user = await db.getUserByEmailAndPassword(email, password);
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
      // Navigate based on role
      Widget home;
      switch (user.role) {
        case 'driver':
          home = const DriverHomeScreen();
          break;
        case 'manager':
          home = const ManagerHomeScreen();
          break;
        case 'student':
          home = const StudentHomeScreen();
          break;
        case 'admin':
          home = const ManagerHomeScreen(); // Placeholder for admin screen
          break;
        default:
          home = const ManagerHomeScreen();
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => home),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.account_circle, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 24),
            const Text('NavWay',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: const Text('Esqueceu a senha?'),
            ),
          ],
        ),
      ),
    );
  }
}
