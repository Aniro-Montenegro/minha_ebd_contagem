import 'package:flutter/material.dart';
import 'package:minha_ebd/model/igreja_model.dart';
import 'package:minha_ebd/repositories/igreja_repository.dart';
import 'package:uuid/uuid.dart';

class IgrejaFormPage extends StatefulWidget {
  final IgrejaModel? igreja;

  const IgrejaFormPage({super.key, this.igreja});

  @override
  State<IgrejaFormPage> createState() => _IgrejaFormPageState();
}

class _IgrejaFormPageState extends State<IgrejaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.igreja != null) {
      _nomeController.text = widget.igreja!.nome ?? '';
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final igreja = IgrejaModel(
        id: widget.igreja?.id ?? const Uuid().v4(),
        nome: _nomeController.text,
      );
      await igrejaRepo.saveIgreja(igreja);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.igreja == null ? "Nova Igreja" : "Editar Igreja"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome da Igreja*"),
                validator:
                    (value) => value?.isEmpty ?? true ? "Informe o nome" : null,
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text(widget.igreja == null ? "Salvar" : "Atualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
