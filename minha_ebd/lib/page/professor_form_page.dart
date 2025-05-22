import 'package:flutter/material.dart';
import 'package:minha_ebd/fragments/appbar_personalizada.dart';
import 'package:minha_ebd/model/professor_model.dart';
import 'package:minha_ebd/repositories/professor_repository.dart';
import 'package:uuid/uuid.dart';

class ProfessorFormPage extends StatefulWidget {
  final ProfessorModel? professor;

  const ProfessorFormPage({super.key, this.professor});

  @override
  State<ProfessorFormPage> createState() => _ProfessorFormPageState();
}

class _ProfessorFormPageState extends State<ProfessorFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  final _repository = ProfessorRepository();

  @override
  void initState() {
    super.initState();
    if (widget.professor != null) {
      _nomeController.text = widget.professor!.name ?? '';
      _emailController.text = widget.professor!.email ?? '';
      _phoneController.text = widget.professor!.phone ?? '';
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final professor = ProfessorModel(
        id: widget.professor?.id ?? const Uuid().v4(),
        name: _nomeController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      if (widget.professor == null) {
        await _repository.addProfessor(professor);
      } else {
        await _repository.updateProfessor(professor);
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizada(
        titulo:
            widget.professor == null ? 'Novo Professor' : 'Editar Professor',
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome*',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o nome do professor';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _salvar,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child:
                            _isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Salvar'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
