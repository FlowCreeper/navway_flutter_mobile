import 'package:flutter/material.dart';
import '../database/app_database.dart';

class ManagerCreateStudentScreen extends StatefulWidget {
  const ManagerCreateStudentScreen({super.key});

  @override
  State<ManagerCreateStudentScreen> createState() => _ManagerCreateStudentScreenState();
}

class _ManagerCreateStudentScreenState extends State<ManagerCreateStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _schoolNameController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        name: _nameController.text,
        birthDate: _birthDateController.text,
        schoolName: _schoolNameController.text,
        active: true,
        userId: 0, // Mock for basic implementation
        companyId: 0, // Mock for basic implementation
        addressId: 0, // Mock for basic implementation
        collegeId: 0, // Mock for basic implementation
      );

      await _dbHelper.createStudent(student);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aluno salvo com sucesso!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _schoolNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Aluno')),
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
                controller: _birthDateController,
                decoration: const InputDecoration(labelText: 'Data de Nascimento'),
                validator: (value) => value == null || value.isEmpty ? 'Informe a data' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _schoolNameController,
                decoration: const InputDecoration(labelText: 'Escola'),
                validator: (value) => value == null || value.isEmpty ? 'Informe a escola' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveStudent,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
