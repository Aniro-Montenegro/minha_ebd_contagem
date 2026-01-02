import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:minha_ebd/config/config_colors.dart';
import 'package:minha_ebd/config/filtro_classe.dart';
import 'package:minha_ebd/fragments/menu_icon_button.dart';
import 'package:minha_ebd/models/classe.dart';
import 'package:minha_ebd/pages/classe_form_page.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  FiltroClasse _filtro = FiltroClasse.ativas;

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Classe>('classes');

    return Scaffold(
      appBar: AppBar(
        leading: const MenuIconButton(),
        title: Text(
          'Classes',
          style: TextStyle(color: ConfigColors.textAppBarTitle),
        ),
        backgroundColor: ConfigColors.primaryBlue,
        actions: [
          PopupMenuButton<FiltroClasse>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (value) {
              setState(() {
                _filtro = value;
              });
            },
            itemBuilder:
                (context) => const [
                  PopupMenuItem(
                    value: FiltroClasse.ativas,
                    child: Text('Ativas'),
                  ),
                  PopupMenuItem(
                    value: FiltroClasse.inativas,
                    child: Text('Inativas'),
                  ),
                  PopupMenuItem(
                    value: FiltroClasse.todas,
                    child: Text('Todas'),
                  ),
                ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ClasseFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Classe> box, _) {
          final classes =
              box.values.where((classe) {
                  switch (_filtro) {
                    case FiltroClasse.ativas:
                      return classe.ativa;
                    case FiltroClasse.inativas:
                      return !classe.ativa;
                    case FiltroClasse.todas:
                      return true;
                  }
                }).toList()
                ..sort((a, b) => a.nome.compareTo(b.nome));

          if (classes.isEmpty) {
            return Center(
              child: Text(
                _filtro == FiltroClasse.ativas
                    ? 'Nenhuma classe ativa'
                    : _filtro == FiltroClasse.inativas
                    ? 'Nenhuma classe inativa'
                    : 'Cadastre classes',
                style: const TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classe = classes[index];

              return Card(
                child: ListTile(
                  title: Text(
                    classe.nome,
                    style: TextStyle(
                      color: classe.ativa ? null : Colors.grey,
                      decoration:
                          classe.ativa ? null : TextDecoration.lineThrough,
                    ),
                  ),
                  subtitle: Text('${classe.faixaEtaria} • ${classe.tipo}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ClasseFormPage(
                              classe: classe,
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
