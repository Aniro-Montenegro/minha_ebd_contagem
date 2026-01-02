import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:minha_ebd/config/config_colors.dart';
import 'package:minha_ebd/config/sexo.dart';
import 'package:minha_ebd/models/professor.dart';

class ProfessorFormPage extends StatefulWidget {
  final Professor? professor;
  final dynamic hiveKey;

  const ProfessorFormPage({super.key, this.professor, this.hiveKey});

  @override
  State<ProfessorFormPage> createState() => _ProfessorFormPageState();
}

class _ProfessorFormPageState extends State<ProfessorFormPage> {
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();

  var maskCellphone = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  String? _sexo;
  bool _ativo = true;

  late Box<Professor> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<Professor>('professores');

    if (widget.professor != null) {
      _nomeController.text = widget.professor!.nome;
      _telefoneController.text = widget.professor!.telefone;
      _sexo = widget.professor!.sexo;
      _ativo = widget.professor!.ativo;
    }
  }

  void _salvar() async {
    if (_nomeController.text.isEmpty ||
        _telefoneController.text.isEmpty ||
        _sexo == null) {
      return;
    }

    final novoProfessor = Professor(
      nome: _nomeController.text.trim(),
      sexo: _sexo!,
      telefone: _telefoneController.text.trim(),
      ativo: _ativo,
    );

    if (widget.professor == null) {
      await box.add(novoProfessor);
    } else {
      await box.put(widget.hiveKey, novoProfessor);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.professor != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editando ? 'Editar Professor' : 'Novo Professor',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: ConfigColors.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _salvar,
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _sexo,
              items:
                  Sexo.valores
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (value) => setState(() => _sexo = value),
              decoration: const InputDecoration(labelText: 'Sexo'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _telefoneController,
              inputFormatters: [maskCellphone],
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              title: const Text('Professor ativo'),
              subtitle: Text(_ativo ? 'Ativo' : 'Inativo'),
              value: _ativo,
              onChanged: (value) {
                setState(() {
                  _ativo = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
