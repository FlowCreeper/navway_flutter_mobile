import 'package:flutter/material.dart';
import '../database/app_database.dart';
import 'manager_create_fleet_screen.dart';
import 'manager_edit_fleet_screen.dart';

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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ManagerEditFleetScreen(fleet: fleet),
                            ),
                          );
                          _loadFleets();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirmar exclusão'),
                              content: const Text('Deseja realmente excluir este veículo?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Excluir'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await _dbHelper.deleteFleet(fleet.id!);
                            _loadFleets();
                          }
                        },
                      ),
                    ],
                  ),
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
