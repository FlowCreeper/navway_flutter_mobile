import 'package:flutter/material.dart';
import '../database/app_database.dart';

class ManagerCreateFleetScreen extends StatefulWidget {
  const ManagerCreateFleetScreen({super.key});

  @override
  State<ManagerCreateFleetScreen> createState() => _ManagerCreateFleetScreenState();
}

class _ManagerCreateFleetScreenState extends State<ManagerCreateFleetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _licensePlateController = TextEditingController();
  final _busModelController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> _saveFleet() async {
    if (_formKey.currentState!.validate()) {
      final fleet = Fleet(
        licensePlate: _licensePlateController.text,
        busModel: _busModelController.text,
      );

      await _dbHelper.createFleet(fleet);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veículo salvo com sucesso!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _licensePlateController.dispose();
    _busModelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Frota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _licensePlateController,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (value) => value == null || value.isEmpty ? 'Informe a placa' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _busModelController,
                decoration: const InputDecoration(labelText: 'Modelo do Ônibus'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o modelo' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveFleet,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
