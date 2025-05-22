import 'package:flutter/material.dart';
import 'package:minha_ebd/fragments/appbar_personalizada.dart';
import 'package:minha_ebd/model/professor_model.dart';
import 'package:minha_ebd/repositories/professor_repository.dart';
import 'package:minha_ebd/page/professor_form_page.dart';
import 'package:signals/signals_flutter.dart';

class ProfessorListPage extends StatefulWidget {
  const ProfessorListPage({super.key});

  @override
  State<ProfessorListPage> createState() => _ProfessorListPageState();
}

class _ProfessorListPageState extends State<ProfessorListPage> {
  final ProfessorRepository _repository = ProfessorRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfessores();
  }

  Future<void> _loadProfessores() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    await _repository.loadProfessores();
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizada(
        titulo: 'Professores',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProfessores,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Watch((context) {
                if (_repository.professores.value.isEmpty) {
                  return const Center(
                    child: Text('Nenhum professor cadastrado'),
                  );
                }

                return ListView.builder(
                  itemCount: _repository.professores.value.length,
                  itemBuilder: (context, index) {
                    final professor = _repository.professores.value[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(professor.name ?? 'Sem nome'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(professor.email ?? 'Sem e-mail'),
                            Text(professor.phone ?? 'Sem telefone'),
                          ],
                        ),
                        onTap: () => _openBottomSheet(context, professor),
                      ),
                    );
                  },
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _navigateToForm(
    BuildContext context, [
    ProfessorModel? professor,
  ]) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ProfessorFormPage(professor: professor),
      ),
    );

    if (result == true && mounted) {
      await _loadProfessores();
    }
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text(
              'Tem certeza que deseja excluir este professor?',
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

    if (confirm == true && mounted) {
      try {
        setState(() => _isLoading = true);
        await _repository.deleteProfessor(id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Professor excluído com sucesso')),
        );
        await _loadProfessores();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir: ${e.toString()}')),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _openBottomSheet(BuildContext context, ProfessorModel professor) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToForm(context, professor);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, professor.id!);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
