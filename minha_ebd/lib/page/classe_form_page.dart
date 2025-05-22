import 'package:flutter/material.dart';
import 'package:minha_ebd/fragments/appbar_personalizada.dart';
import 'package:minha_ebd/model/classe_model.dart';
import 'package:minha_ebd/model/professor_model.dart';
import 'package:minha_ebd/repositories/classe_reporitory.dart';
import 'package:minha_ebd/repositories/professor_repository.dart';
import 'package:uuid/uuid.dart';

class ClasseFormPage extends StatefulWidget {
  final ClasseModel? classe;

  const ClasseFormPage({super.key, this.classe});

  @override
  State<ClasseFormPage> createState() => _ClasseFormPageState();
}

class _ClasseFormPageState extends State<ClasseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  bool _ativo = true;
  bool _isLoading = false;
  final _repository = ClasseRepository();
  final _professorRepository = ProfessorRepository();
  List<ProfessorModel> _professores = [];
  List<String> _professoresSelecionados = [];

  final List<String> _faixasEtarias = [
    'Berçário (0-2 anos)',
    'Maternal (2-3 anos)',
    'Jardim (4-5 anos)',
    'Primários (6-8 anos)',
    'Juniores (9-11 anos)',
    'Pré-adolescentes (12-14 anos)',
    'Adolescentes (15-17 anos)',
    'Jovens (18-25 anos)',
    'Adultos (26-40 anos)',
    'Melhor Idade (41-60 anos)',
    'Seniores (61+ anos)',
  ];

  final List<String> _tiposClasse = ['Homens', 'Mulheres', 'Mista'];

  String? _faixaEtariaSelecionada;
  String? _tipoClasseSelecionado;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    if (widget.classe != null) {
      _nomeController.text = widget.classe!.nome ?? '';
      _descricaoController.text = widget.classe!.descricao ?? '';
      _faixaEtariaSelecionada = widget.classe!.faixaEtaria;
      _tipoClasseSelecionado = widget.classe!.tipoClasse;
      _ativo = widget.classe!.ativo ?? true;
    }

    await _loadProfessores();
    if (widget.classe?.id != null) {
      await _loadProfessoresDaClasse();
    }
  }

  Future<void> _loadProfessores() async {
    setState(() => _isLoading = true);
    await _professorRepository.loadProfessores();
    if (!mounted) return;
    setState(() {
      _professores = _professorRepository.professores.value;
      _isLoading = false;
    });
  }

  Future<void> _loadProfessoresDaClasse() async {
    if (widget.classe?.id != null) {
      setState(() => _isLoading = true);
      final professores = await _repository.getProfessoresDaClasse(
        widget.classe!.id!,
      );
      if (!mounted) return;
      setState(() {
        _professoresSelecionados = professores.map((p) => p.id!).toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final classe = ClasseModel(
        id: widget.classe?.id ?? const Uuid().v4(),
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        dataCriacao:
            widget.classe?.dataCriacao ?? DateTime.now().toIso8601String(),
        ativo: _ativo,
        faixaEtaria: _faixaEtariaSelecionada,
        tipoClasse: _tipoClasseSelecionado,
      );

      if (widget.classe == null) {
        await _repository.addClasse(classe, _professoresSelecionados);
      } else {
        await _repository.updateClasse(classe, _professoresSelecionados);
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
        titulo: widget.classe == null ? 'Nova Classe' : 'Editar Classe',
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
                          labelText: 'Nome da Classe*',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o nome da classe';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descricaoController,
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _faixaEtariaSelecionada,
                        decoration: const InputDecoration(
                          labelText: 'Faixa Etária',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            _faixasEtarias
                                .map(
                                  (faixa) => DropdownMenuItem(
                                    value: faixa,
                                    child: Text(faixa),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) =>
                                setState(() => _faixaEtariaSelecionada = value),
                        hint: const Text('Selecione a faixa etária'),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _tipoClasseSelecionado,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de Classe',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            _tiposClasse
                                .map(
                                  (tipo) => DropdownMenuItem(
                                    value: tipo,
                                    child: Text(tipo),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) =>
                                setState(() => _tipoClasseSelecionado = value),
                        hint: const Text('Selecione o tipo de classe'),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Classe ativa'),
                        value: _ativo,
                        onChanged: (value) => setState(() => _ativo = value),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Professores:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildProfessoresList(),
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

  Widget _buildProfessoresList() {
    if (_professores.isEmpty) {
      return const Text('Nenhum professor cadastrado');
    }

    return Column(
      children:
          _professores.map((professor) {
            return CheckboxListTile(
              title: Text(professor.name ?? 'Sem nome'),
              value: _professoresSelecionados.contains(professor.id),
              onChanged: (selected) {
                setState(() {
                  if (selected == true) {
                    _professoresSelecionados.add(professor.id!);
                  } else {
                    _professoresSelecionados.remove(professor.id);
                  }
                });
              },
            );
          }).toList(),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }
}
