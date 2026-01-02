import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:minha_ebd/config/config_colors.dart';
import 'package:minha_ebd/config/faixa_etaria.dart';
import 'package:minha_ebd/config/tipo_classe.dart';
import 'package:minha_ebd/models/classe.dart';

class ClasseFormPage extends StatefulWidget {
  final Classe? classe;
  final dynamic hiveKey;

  const ClasseFormPage({super.key, this.classe, this.hiveKey});

  @override
  State<ClasseFormPage> createState() => _ClasseFormPageState();
}

class _ClasseFormPageState extends State<ClasseFormPage> {
  final _nomeController = TextEditingController();

  String? _faixaEtaria;
  String? _tipo;
  bool _ativa = true;

  late Box<Classe> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<Classe>('classes');

    if (widget.classe != null) {
      _nomeController.text = widget.classe!.nome;
      _faixaEtaria = widget.classe!.faixaEtaria;
      _tipo = widget.classe!.tipo;
      _ativa = widget.classe!.ativa;
    }
  }

  void _salvar() async {
    if (_nomeController.text.isEmpty || _faixaEtaria == null || _tipo == null) {
      return;
    }

    final novaClasse = Classe(
      nome: _nomeController.text.trim(),
      faixaEtaria: _faixaEtaria!,
      tipo: _tipo!,
      ativa: _ativa,
    );

    if (widget.classe == null) {
      await box.add(novaClasse);
    } else {
      await box.put(widget.hiveKey, novaClasse);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.classe != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editando ? 'Editar Classe' : 'Nova Classe',
          style: TextStyle(color: ConfigColors.textAppBarTitle),
        ),
        backgroundColor: ConfigColors.primaryBlue,
        iconTheme: IconThemeData(color: ConfigColors.textAppBarTitle),
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
              decoration: const InputDecoration(labelText: 'Nome da Classe'),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _faixaEtaria,
              items:
                  FaixaEtaria.valores
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (value) => setState(() => _faixaEtaria = value),
              decoration: const InputDecoration(labelText: 'Faixa Etária'),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _tipo,
              items:
                  TipoClasse.valores
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (value) => setState(() => _tipo = value),
              decoration: const InputDecoration(labelText: 'Tipo da Classe'),
            ),
            SwitchListTile(
              title: const Text('Classe ativa'),
              value: _ativa,
              onChanged: (value) {
                setState(() {
                  _ativa = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
