import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:minha_ebd/config/config_colors.dart';
import 'package:minha_ebd/fragments/menu_icon_button.dart';
import 'package:minha_ebd/models/aulas_com_key.dart';
import 'package:minha_ebd/models/classe.dart';
import 'package:minha_ebd/models/professor.dart';
import 'package:minha_ebd/pages/relatorio_aulas_page.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:minha_ebd/models/aula.dart';
import 'package:minha_ebd/pages/aula_form_page.dart';

class AulasPage extends StatefulWidget {
  const AulasPage({super.key});

  @override
  State<AulasPage> createState() => _AulasPageState();
}

class _AulasPageState extends State<AulasPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  late Box<Aula> aulaBox;
  late Box<Professor> professorBox;
  late Box<Classe> classeBox;

  @override
  void initState() {
    super.initState();
    aulaBox = Hive.box<Aula>('aulas');
    professorBox = Hive.box<Professor>('professores');
    classeBox = Hive.box<Classe>('classes');
  }

  List<AulaComKey> _aulasDoDia(DateTime dia) {
    final List<AulaComKey> result = [];

    for (var key in aulaBox.keys) {
      final aula = aulaBox.get(key);

      if (aula == null) continue;

      if (aula.data.year == dia.year &&
          aula.data.month == dia.month &&
          aula.data.day == dia.day) {
        result.add(AulaComKey(key: key as int, aula: aula));
      }
    }

    result.sort((a, b) => a.aula.data.compareTo(b.aula.data));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const MenuIconButton(),
        title: Text(
          'Aulas',
          style: TextStyle(color: ConfigColors.textAppBarTitle),
        ),
        backgroundColor: ConfigColors.primaryBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.description),
            tooltip: 'Relatório do dia',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RelatorioAulasPage(dia: _selectedDay),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novaAula = Aula(
            data: DateTime(
              _selectedDay.year,
              _selectedDay.month,
              _selectedDay.day,
            ),
            professorKey: -1,
            classeKey: -1,
            presentes: 0,
          );

          final key = await aulaBox.add(novaAula);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AulaFormPage(aula: novaAula, hiveKey: key),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: aulaBox.listenable(),
        builder: (context, Box<Aula> box, _) {
          final aulasSelecionadas = _aulasDoDia(_selectedDay);

          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime(2020),
                lastDay: DateTime(2035),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  });
                },
                eventLoader: _aulasDoDia,
                calendarStyle: const CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child:
                    aulasSelecionadas.isEmpty
                        ? const Center(child: Text('Nenhuma aula neste dia'))
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: aulasSelecionadas.length,
                          itemBuilder: (context, index) {
                            final item = aulasSelecionadas[index];
                            final aula = item.aula;

                            final professor = professorBox.get(
                              aula.professorKey,
                            );
                            final classe = classeBox.get(aula.classeKey);

                            return Card(
                              child: ListTile(
                                title: Text(classe?.nome ?? 'Classe removida'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${professor?.nome ?? 'Professor removido'}'
                                      ' • ${aula.data.hour.toString().padLeft(2, '0')}:'
                                      '${aula.data.minute.toString().padLeft(2, '0')}',
                                    ),
                                    Text('Presentes: ${aula.presentes}'),
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => AulaFormPage(
                                            aula: aula,
                                            hiveKey: item.key, // ✅ key correta
                                          ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
