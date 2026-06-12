import 'package:flutter/material.dart';
import '../database/app_database.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ManagerEditFleetScreen extends StatefulWidget {
  final Fleet fleet;
  const ManagerEditFleetScreen({required this.fleet, super.key});

  @override
  State<ManagerEditFleetScreen> createState() => _ManagerEditFleetScreenState();
}

class _ManagerEditFleetScreenState extends State<ManagerEditFleetScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _licensePlateController;
  final TextEditingController _busModelController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  late final MaskTextInputFormatter _plateMask;
  @override
  void initState() {
    super.initState();
    _plateMask = MaskTextInputFormatter(
      mask: 'AAA-9A99',
      filter: {
        'A': RegExp(r'[A-Z]'),
        '9': RegExp(r'[0-9]'),
      },

    );
    final formatted = _plateMask.maskText(widget.fleet.licensePlate);
    _licensePlateController = TextEditingController(text: formatted);
    _licensePlateController.selection = TextSelection.collapsed(offset: formatted.length);
    _busModelController.text = widget.fleet.busModel;
  }

  Future<void> _updateFleet() async {
    if (_formKey.currentState!.validate()) {
      final updatedFleet = Fleet(
        id: widget.fleet.id,
        licensePlate: _licensePlateController.text,
        busModel: _busModelController.text,
      );
      // Check for duplicate license plate if changed
      final existing = await _dbHelper.getFleetByPlate(_licensePlateController.text);
      if (existing != null && existing.id != widget.fleet.id) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Placa já cadastrada.')),
        );
        return;
      }

      await _dbHelper.updateFleet(updatedFleet);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veículo atualizado com sucesso!')),
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
      appBar: AppBar(title: const Text('Editar Frota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _licensePlateController,
                inputFormatters: [_plateMask],
                textCapitalization: TextCapitalization.characters,
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
                onPressed: _updateFleet,
                child: const Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
