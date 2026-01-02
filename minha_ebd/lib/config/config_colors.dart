import 'package:flutter/material.dart';

class ConfigColors {
  // Cores principais do tema
  static Color primaryBlue = const Color(0xFF035AA6);
  static Color primaryBlueLight1 = const Color(0xFF3A7BB8);
  static Color primaryBlueLight2 = const Color(0xFF6F9CCB);
  static Color primaryBlueLight3 = const Color(0xFFA4BDDD);
  static Color accentYellow = const Color(0xFFBBBF45);
  static Color darkOlive = const Color(0xFF736D24);
  static Color lightBeige = const Color(0xFFD9C7B8);
  static Color warmBrown = const Color(0xFFA66038);

  // color text appBar title
  static Color textAppBarTitle = const Color(0xFFF2F2F2);

  // color text title card home page
  static Color textTitleCardHomePage = const Color(0xFF0B0C0D);

  // Versões RGBA (opcionais - se precisar de transparência)
  static Color primaryBlueWithOpacity = const Color.fromRGBO(3, 89, 165, 1.0);
  static Color accentYellowWithOpacity = const Color.fromRGBO(
    187,
    191,
    68,
    1.0,
  );
  static Color darkOliveWithOpacity = const Color.fromRGBO(114, 109, 35, 1.0);
  static Color lightBeigeWithOpacity = const Color.fromRGBO(216, 199, 184, 1.0);
  static Color warmBrownWithOpacity = const Color.fromRGBO(165, 96, 56, 1.0);
}
