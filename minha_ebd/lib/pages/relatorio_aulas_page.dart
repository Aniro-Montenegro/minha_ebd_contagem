import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:minha_ebd/models/aula.dart';
import 'package:minha_ebd/models/classe.dart';
import 'package:minha_ebd/models/professor.dart';

class RelatorioAulasPage extends StatelessWidget {
  final DateTime dia;

  const RelatorioAulasPage({super.key, required this.dia});

  List<Aula> _aulasDoDia(Box<Aula> aulaBox) {
    return aulaBox.values.where((aula) {
        return aula.data.year == dia.year &&
            aula.data.month == dia.month &&
            aula.data.day == dia.day;
      }).toList()
      ..sort((a, b) => a.data.compareTo(b.data));
  }

  @override
  Widget build(BuildContext context) {
    final aulaBox = Hive.box<Aula>('aulas');
    final professorBox = Hive.box<Professor>('professores');
    final classeBox = Hive.box<Classe>('classes');

    final aulas = _aulasDoDia(aulaBox);

    final totalPresentes = aulas.fold<int>(0, (sum, a) => sum + a.presentes);

    final totalOfertas = aulas.fold<double>(0, (sum, a) => sum + a.ofertas);

    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório - ${DateFormat('dd/MM/yyyy').format(dia)}'),
      ),
      body:
          aulas.isEmpty
              ? const Center(child: Text('Nenhuma aula neste dia'))
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  /// 🔹 RESUMO
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Resumo do dia',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Aulas: ${aulas.length}'),
                          Text('Total de presentes: $totalPresentes'),
                          Text(
                            'Total de ofertas: R\$ ${totalOfertas.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 LISTA DE AULAS
                  ...aulas.map((aula) {
                    final professor = professorBox.get(aula.professorKey);
                    final classe = classeBox.get(aula.classeKey);

                    return Card(
                      child: ListTile(
                        title: Text(classe?.nome ?? 'Classe removida'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(professor?.nome ?? 'Professor removido'),
                            Text(
                              'Horário: ${DateFormat('HH:mm').format(aula.data)}',
                            ),
                            Text('Presentes: ${aula.presentes}'),
                            Text(
                              'Oferta: R\$ ${aula.ofertas.toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
    );
  }
}
