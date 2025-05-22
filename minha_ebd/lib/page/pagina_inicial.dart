import 'package:flutter/material.dart';
import 'package:minha_ebd/config/config_colors.dart';
import 'package:minha_ebd/fragments/appbar_personalizada.dart';
import 'package:minha_ebd/services/navigation_pages.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  // Lista de itens do dashboard
  final List<DashboardItem> _itens = [
    DashboardItem(
      titulo: 'Igreja',
      icone: Icons.church_rounded,
      cor: Colors.blue,
      rota: '/igrejas_page',
    ),
    DashboardItem(
      titulo: 'Classes',
      icone: Icons.class_rounded,
      cor: Colors.blue,
      rota: '/classes_page',
    ),
    DashboardItem(
      titulo: 'Professores',
      icone: Icons.class_rounded,
      cor: Colors.blue,
      rota: '/professores_page',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizada(titulo: 'Studioso'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children:
              _itens.map((item) => _buildDashboardCard(item, context)).toList(),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(DashboardItem item, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: ConfigColors.lightGray,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          NavigationPages.navigateToHomePage(item.rota, context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icone, size: 40, color: item.cor),
              const SizedBox(height: 8),
              Text(
                item.titulo,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: item.cor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardItem {
  final String titulo;
  final IconData icone;
  final Color cor;
  final String rota;

  DashboardItem({
    required this.titulo,
    required this.icone,
    required this.cor,
    required this.rota,
  });
}
