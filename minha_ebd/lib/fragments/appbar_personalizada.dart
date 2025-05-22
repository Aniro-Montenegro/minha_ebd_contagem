import 'package:flutter/material.dart';
import 'package:minha_ebd/config/config_colors.dart';
import 'package:minha_ebd/fragments/textos_widgets.dart';

class AppBarPersonalizada extends StatelessWidget
    implements PreferredSizeWidget {
  final String titulo;
  final double fontSize;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Widget? leading;

  const AppBarPersonalizada({
    super.key,
    required this.titulo,
    this.fontSize = 26,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ConfigColors.bibleGreen2,
      title: TextosWidget.tituloAppBar(titulo, fontSize: fontSize),
      actionsPadding: EdgeInsets.symmetric(horizontal: 8),
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      centerTitle: true,
      elevation: 4,
      iconTheme: IconThemeData(color: ConfigColors.lightGray, size: 20),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
