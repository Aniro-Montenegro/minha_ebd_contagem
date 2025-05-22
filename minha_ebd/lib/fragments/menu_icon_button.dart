import 'package:flutter/material.dart';
import 'package:minha_ebd/page/pagina_inicial.dart';

class MenuIconButton extends StatelessWidget {
  const MenuIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
      tooltip: 'Voltar ao início',
      onPressed: () => _voltarParaHome(context),
    );
  }

  void _voltarParaHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const PaginaInicial()),
      (Route<dynamic> route) => false,
    );
  }
}
