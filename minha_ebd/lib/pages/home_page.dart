import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:minha_ebd/config/config_colors.dart';
import 'package:minha_ebd/fragments/menu_item.dart';
import 'package:minha_ebd/models/igreja.dart';
import 'package:minha_ebd/pages/aulas_page.dart';
import 'package:minha_ebd/pages/classes_page.dart';
import 'package:minha_ebd/pages/igreja_page.dart';
import 'package:minha_ebd/pages/professores_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String igrejaKey = 'igreja_principal';
  late Box<Igreja> igrejaBox;
  bool isIgrejaSetUp = false;

  @override
  initState() {
    super.initState();
    igrejaBox = Hive.box<Igreja>('igrejas');

    final igreja = igrejaBox.get(igrejaKey);
    if (igreja != null) {
      setState(() {
        isIgrejaSetUp = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minha EBD',
          style: TextStyle(color: ConfigColors.textAppBarTitle),
        ),
        backgroundColor: ConfigColors.primaryBlue,
      ),
      body: GridView.count(
        crossAxisCount: 2, // 🔹 duas colunas
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          MenuItem(
            icon: Icons.church,
            label: 'Igrejas',
            destination: IgrejaPage(),
          ),
          MenuItem(
            icon: Icons.groups,
            label: 'Classes',
            destination: isIgrejaSetUp ? ClassesPage() : IgrejaPage(),
          ),
          MenuItem(
            icon: Icons.school,
            label: 'Professores',
            destination: isIgrejaSetUp ? ProfessoresPage() : IgrejaPage(),
          ),
          MenuItem(
            icon: Icons.menu_book,
            label: 'Aulas',
            destination: isIgrejaSetUp ? AulasPage() : IgrejaPage(),
          ),
        ],
      ),
    );
  }
}
