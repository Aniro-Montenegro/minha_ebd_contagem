import 'package:flutter/material.dart';
import 'package:minha_ebd/pages/home_page.dart';
import 'package:minha_ebd/services/navigato_to_page.dart';

class MenuIconButton extends StatelessWidget {
  const MenuIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu, color: Colors.white),
      onPressed: () {
        NavigateToPage.toWidget(context, const HomePage());
      },
    );
  }
}
