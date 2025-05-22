import 'package:flutter/material.dart';
import 'package:minha_ebd/fragments/appbar_personalizada.dart';
import 'package:minha_ebd/model/classe_model.dart';
import 'package:minha_ebd/repositories/classe_reporitory.dart';
import 'package:minha_ebd/page/classe_form_page.dart';
import 'package:signals/signals_flutter.dart';

class ClasseListPage extends StatefulWidget {
  const ClasseListPage({super.key});

  @override
  State<ClasseListPage> createState() => _ClasseListPageState();
}

class _ClasseListPageState extends State<ClasseListPage> {
  final ClasseRepository _repository = ClasseRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    await _repository.loadClasses();
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizada(
        titulo: 'Classes da EBD',
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadClasses),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Watch((context) {
                if (_repository.classes.value.isEmpty) {
                  return const Center(child: Text('Nenhuma classe cadastrada'));
                }

                return ListView.builder(
                  itemCount: _repository.classes.value.length,
                  itemBuilder: (context, index) {
                    final classe = _repository.classes.value[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(classe.nome ?? 'Sem nome'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(classe.descricao ?? 'Sem descrição'),
                            Text(
                              'Faixa etária: ${classe.faixaEtaria ?? 'Não informada'}',
                            ),
                            Text(
                              'Tipo: ${classe.tipoClasse ?? 'Não informado'}',
                            ),
                            Text(classe.ativo == true ? 'Ativa' : 'Inativa'),
                          ],
                        ),
                        onTap: () => _openBottomSheet(context, classe),
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
    ClasseModel? classe,
  ]) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => ClasseFormPage(classe: classe)),
    );

    if (result == true && mounted) {
      await _loadClasses();
    }
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Tem certeza que deseja excluir esta classe?'),
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
        await _repository.deleteClasse(id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Classe excluída com sucesso')),
        );
        await _loadClasses();
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

  void _openBottomSheet(BuildContext context, ClasseModel classe) {
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
                  _navigateToForm(context, classe);
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
                  _confirmDelete(context, classe.id!);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
