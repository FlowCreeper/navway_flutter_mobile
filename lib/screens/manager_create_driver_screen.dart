import 'package:flutter/material.dart';
import '../database/app_database.dart';

class ManagerCreateDriverScreen extends StatefulWidget {
  const ManagerCreateDriverScreen({super.key});

  @override
  State<ManagerCreateDriverScreen> createState() => _ManagerCreateDriverScreenState();
}

class _ManagerCreateDriverScreenState extends State<ManagerCreateDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _licenseController = TextEditingController();
  final _birthDateController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> _saveDriver() async {
    if (_formKey.currentState!.validate()) {
      final driver = Driver(
        name: _nameController.text,
        driverLicense: _licenseController.text,
        birthDate: _birthDateController.text,
        userId: 0, // Mock for basic implementation
        companyId: 0, // Mock for basic implementation
      );

      await _dbHelper.createDriver(driver);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Motorista salvo com sucesso!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _licenseController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Motorista')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _licenseController,
                decoration: const InputDecoration(labelText: 'Documento de Habilitação'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o documento' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthDateController,
                decoration: const InputDecoration(labelText: 'Data de Aniversário'),
                validator: (value) => value == null || value.isEmpty ? 'Informe a data' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveDriver,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
