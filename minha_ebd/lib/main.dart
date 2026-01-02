import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minha_ebd/pages/home_page.dart';

import 'package:hive_ce_flutter/hive_flutter.dart';

// Models
import 'package:minha_ebd/models/igreja.dart';
import 'package:minha_ebd/models/superintendente.dart';
import 'package:minha_ebd/models/professor.dart';
import 'package:minha_ebd/models/classe.dart';
import 'package:minha_ebd/models/aula.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Inicializa o Hive CE
  await Hive.initFlutter();

  // 🔹 Registra os adapters
  Hive.registerAdapter(IgrejaAdapter());
  Hive.registerAdapter(SuperintendenteAdapter());
  Hive.registerAdapter(ProfessorAdapter());
  Hive.registerAdapter(ClasseAdapter());
  Hive.registerAdapter(AulaAdapter());

  // 🔹 Abre os boxes
  await Hive.openBox<Igreja>('igrejas');
  await Hive.openBox<Superintendente>('superintendentes');
  await Hive.openBox<Professor>('professores');
  await Hive.openBox<Classe>('classes');
  await Hive.openBox<Aula>('aulas');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      title: 'Minha EBD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
