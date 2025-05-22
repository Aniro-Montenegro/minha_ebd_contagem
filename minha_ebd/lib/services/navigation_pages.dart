import 'package:flutter/material.dart';
import 'package:minha_ebd/page/classe_form_page.dart';
import 'package:minha_ebd/page/classe_lista_page.dart';
import 'package:minha_ebd/page/igreja_list_page.dart';
import 'package:minha_ebd/page/professor_lista_page.dart';

class NavigationPages {
  static void navigateToHomePage(String rota, BuildContext context) {
    switch (rota) {
      case '/igrejas_page':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const IgrejaPage()));
        break;

      case '/classes_page':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => ClasseListPage()));
        break;

      case '/nova_classe':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const ClasseFormPage()));
        break;
      case '/professores_page':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ProfessorListPage()),
        );
        break;

      default:
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const IgrejaPage()));
    }
  }
}
