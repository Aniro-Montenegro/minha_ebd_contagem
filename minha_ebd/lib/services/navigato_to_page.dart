import 'package:flutter/material.dart';

class NavigateToPage {
  // Para rotas nomeadas
  static void to(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  // Para rotas não nomeadas (widget)
  static void toWidget(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (route) => false,
    );
  }
}
