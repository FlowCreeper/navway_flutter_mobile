import 'package:flutter/material.dart';
import '../database/app_database.dart';
import 'manager_create_fleet_screen.dart';

class ManagerFleetListScreen extends StatefulWidget {
  const ManagerFleetListScreen({super.key});

  @override
  State<ManagerFleetListScreen> createState() => _ManagerFleetListScreenState();
}

class _ManagerFleetListScreenState extends State<ManagerFleetListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Fleet> _fleets = [];

  @override
  void initState() {
    super.initState();
    _loadFleets();
  }

  Future<void> _loadFleets() async {
    final fleets = await _dbHelper.getAllFleets();
    setState(() {
      _fleets = fleets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frota'),
      ),
      body: _fleets.isEmpty
          ? const Center(child: Text('Nenhum veículo cadastrado.'))
          : ListView.builder(
              itemCount: _fleets.length,
              itemBuilder: (context, index) {
                final fleet = _fleets[index];
                return ListTile(
                  leading: const Icon(Icons.directions_bus),
                  title: Text(fleet.licensePlate),
                  subtitle: Text(fleet.busModel),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ManagerCreateFleetScreen()),
          );
          _loadFleets(); // Recarrega a lista após criar
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
