import 'package:flutter/material.dart';
import '../database/app_database.dart';
import 'manager_create_driver_screen.dart';

class ManagerDriverListScreen extends StatefulWidget {
  const ManagerDriverListScreen({super.key});

  @override
  State<ManagerDriverListScreen> createState() => _ManagerDriverListScreenState();
}

class _ManagerDriverListScreenState extends State<ManagerDriverListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Driver> _drivers = [];

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  Future<void> _loadDrivers() async {
    final drivers = await _dbHelper.getAllDrivers();
    setState(() {
      _drivers = drivers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motoristas'),
      ),
      body: _drivers.isEmpty
          ? const Center(child: Text('Nenhum motorista cadastrado.'))
          : ListView.builder(
              itemCount: _drivers.length,
              itemBuilder: (context, index) {
                final driver = _drivers[index];
                return ListTile(
                  leading: const Icon(Icons.badge),
                  title: Text(driver.name),
                  subtitle: Text('CNH: ${driver.driverLicense} | Nasc: ${driver.birthDate}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ManagerCreateDriverScreen()),
          );
          _loadDrivers();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
