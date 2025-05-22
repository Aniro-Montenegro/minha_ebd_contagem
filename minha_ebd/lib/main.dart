import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minha_ebd/bd/database_helper.dart';
import 'package:minha_ebd/page/igreja_form_page.dart';
import 'package:minha_ebd/page/igreja_list_page.dart';
import 'package:minha_ebd/page/pagina_inicial.dart';
import 'package:minha_ebd/page/professor_lista_page.dart';
import 'package:minha_ebd/screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;

  runApp(MyApp());
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

      title: 'Studioso',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/pagina_inicial': (context) => PaginaInicial(),
        '/igrejas_page': (context) => IgrejaPage(),
        '/igreja_form': (context) => IgrejaFormPage(),
        '/professores_page': (context) => ProfessorListPage(),
      },
      home: SplashScreen(
        duration: const Duration(milliseconds: 3000),
        nextScreen: PaginaInicial(),
      ),
    );
  }
}
