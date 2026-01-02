import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:minha_ebd/config/config_colors.dart';
import 'package:minha_ebd/config/filtos_professor.dart';
import 'package:minha_ebd/fragments/menu_icon_button.dart';
import 'package:minha_ebd/models/professor.dart';
import 'package:minha_ebd/pages/professor_form_page.dart';

class ProfessoresPage extends StatefulWidget {
  const ProfessoresPage({super.key});

  @override
  State<ProfessoresPage> createState() => _ProfessoresPageState();
}

class _ProfessoresPageState extends State<ProfessoresPage> {
  FiltroProfessor _filtro = FiltroProfessor.ativos;
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Professor>('professores');

    return Scaffold(
      appBar: AppBar(
        leading: const MenuIconButton(),
        title: Text(
          'Professores',
          style: TextStyle(color: ConfigColors.textAppBarTitle),
        ),
        backgroundColor: ConfigColors.primaryBlue,
        actions: [
          PopupMenuButton<FiltroProfessor>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (value) {
              setState(() {
                _filtro = value;
              });
            },
            itemBuilder:
                (context) => const [
                  PopupMenuItem(
                    value: FiltroProfessor.ativos,
                    child: Text('Ativos'),
                  ),
                  PopupMenuItem(
                    value: FiltroProfessor.inativos,
                    child: Text('Inativos'),
                  ),
                  PopupMenuItem(
                    value: FiltroProfessor.todos,
                    child: Text('Todos'),
                  ),
                ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfessorFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Professor> box, _) {
          final professores =
              box.values.where((professor) {
                  switch (_filtro) {
                    case FiltroProfessor.ativos:
                      return professor.ativo;
                    case FiltroProfessor.inativos:
                      return !professor.ativo;
                    case FiltroProfessor.todos:
                      return true;
                  }
                }).toList()
                ..sort((a, b) => a.nome.compareTo(b.nome));

          if (professores.isEmpty) {
            return Center(
              child: Text(
                _filtro == FiltroProfessor.ativos
                    ? 'Nenhum professor ativo'
                    : _filtro == FiltroProfessor.inativos
                    ? 'Nenhum professor inativo'
                    : 'Cadastre professores',
                style: const TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: professores.length,
            itemBuilder: (context, index) {
              final professor = professores[index];

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(
                    professor.nome,
                    style: TextStyle(
                      color: professor.ativo ? null : Colors.grey,
                      decoration:
                          professor.ativo ? null : TextDecoration.lineThrough,
                    ),
                  ),
                  subtitle: Text('${professor.sexo} • ${professor.telefone}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ProfessorFormPage(
                              professor: professor,
                              hiveKey: box.keyAt(index),
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
