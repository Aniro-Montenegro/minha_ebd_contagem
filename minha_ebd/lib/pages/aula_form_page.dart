import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:minha_ebd/config/config_colors.dart';
import 'package:minha_ebd/models/aula.dart';
import 'package:minha_ebd/models/classe.dart';
import 'package:minha_ebd/models/professor.dart';

class AulaFormPage extends StatefulWidget {
  final Aula aula;
  final dynamic hiveKey;

  const AulaFormPage({super.key, required this.aula, required this.hiveKey});

  @override
  State<AulaFormPage> createState() => _AulaFormPageState();
}

class _AulaFormPageState extends State<AulaFormPage> {
  late DateTime _data;

  int _presentes = 0;

  late Box<Aula> aulaBox;
  late Box<Professor> professorBox;
  late Box<Classe> classeBox;
  int? _professorKey;
  int? _classeKey;
  double _ofertas = 0.0;

  @override
  void initState() {
    super.initState();

    aulaBox = Hive.box<Aula>('aulas');
    professorBox = Hive.box<Professor>('professores');
    classeBox = Hive.box<Classe>('classes');

    _data = widget.aula.data;
    _professorKey =
        widget.aula.professorKey >= 0 ? widget.aula.professorKey : null;
    _classeKey = widget.aula.classeKey >= 0 ? widget.aula.classeKey : null;
    _presentes = widget.aula.presentes;
    _ofertas = widget.aula.ofertas;
  }

  Future<void> _selecionarDataHora() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (data == null) return;

    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_data),
    );

    if (hora == null) return;

    setState(() {
      _data = DateTime(data.year, data.month, data.day, hora.hour, hora.minute);
    });
  }

  void _salvar() async {
    if (_professorKey == null || _classeKey == null) return;

    final aulaAtualizada = Aula(
      data: _data,
      professorKey: _professorKey!,
      classeKey: _classeKey!,
      presentes: _presentes,
      ofertas: _ofertas,
    );

    await aulaBox.put(widget.hiveKey, aulaAtualizada);
    Navigator.pop(context);
  }

  Future<void> _confirmarExclusao() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Excluir aula'),
            content: const Text(
              'Tem certeza que deseja excluir esta aula? '
              'Essa ação não pode ser desfeita.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmar == true) {
      await aulaBox.delete(widget.hiveKey);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aula',
          style: TextStyle(color: ConfigColors.textAppBarTitle),
        ),
        backgroundColor: ConfigColors.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmarExclusao,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _salvar,
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Data e hora'),
              subtitle: Text(_data.toString()),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selecionarDataHora,
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<int>(
              value: _classeKey,
              items:
                  classeBox.keys
                      .where((key) => classeBox.get(key)!.ativa)
                      .map(
                        (key) => DropdownMenuItem<int>(
                          value: key as int,
                          child: Text(classeBox.get(key)!.nome),
                        ),
                      )
                      .toList(),
              onChanged: (value) => setState(() => _classeKey = value),
              decoration: const InputDecoration(labelText: 'Classe'),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<int>(
              value: _professorKey,
              items:
                  professorBox.keys
                      .where((key) => professorBox.get(key)!.ativo)
                      .map(
                        (key) => DropdownMenuItem<int>(
                          value: key as int,
                          child: Text(professorBox.get(key)!.nome),
                        ),
                      )
                      .toList(),
              onChanged: (value) => setState(() => _professorKey = value),
              decoration: const InputDecoration(labelText: 'Professor'),
            ),

            const SizedBox(height: 16),

            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Presentes'),
              controller: TextEditingController(text: _presentes.toString()),
              onChanged: (v) => _presentes = int.tryParse(v) ?? 0,
            ),
            const SizedBox(height: 16),

            TextField(
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Ofertas (R\$)',
                prefixText: 'R\$ ',
              ),
              controller: TextEditingController(
                text: _ofertas.toStringAsFixed(2),
              ),
              onChanged: (v) {
                _ofertas = double.tryParse(v.replaceAll(',', '.')) ?? 0.0;
              },
            ),
          ],
        ),
      ),
    );
  }
}
