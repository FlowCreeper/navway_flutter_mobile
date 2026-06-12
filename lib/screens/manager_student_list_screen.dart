import 'package:flutter/material.dart';
import '../database/app_database.dart';
import 'manager_create_student_screen.dart';

class ManagerStudentListScreen extends StatefulWidget {
  const ManagerStudentListScreen({super.key});

  @override
  State<ManagerStudentListScreen> createState() => _ManagerStudentListScreenState();
}

class _ManagerStudentListScreenState extends State<ManagerStudentListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final students = await _dbHelper.getAllStudents();
    setState(() {
      _students = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alunos'),
      ),
      body: _students.isEmpty
          ? const Center(child: Text('Nenhum aluno cadastrado.'))
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(student.name),
                  subtitle: Text('Escola: ${student.schoolName} | Nasc: ${student.birthDate}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ManagerCreateStudentScreen()),
          );
          _loadStudents();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
