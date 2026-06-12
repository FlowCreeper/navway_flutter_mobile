import 'package:flutter/material.dart';
import 'manager_fleet_list_screen.dart';
import 'manager_student_list_screen.dart';
import 'manager_driver_list_screen.dart';

class ManagerHomeScreen extends StatelessWidget {
  const ManagerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel do Administrador')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.directions_bus),
              title: const Text('Frota'),
              onTap: () {
                Navigator.pop(context); // Fechar drawer
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ManagerFleetListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Alunos'),
              onTap: () {
                Navigator.pop(context); // Fechar drawer
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ManagerStudentListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Motoristas'),
              onTap: () {
                Navigator.pop(context); // Fechar drawer
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ManagerDriverListScreen()));
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Bem-vindo ao Painel do Administrador!'),
      ),
    );
  }
}
