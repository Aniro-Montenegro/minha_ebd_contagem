import 'package:flutter/material.dart';

class ConfigColors {
  // Cores originais mantidas
  static const Color appBlack = Color(0xFF03060D);
  static const Color colorGreen = Color(0xFF5DD91A);
  static const Color mahogany = Color(0xFF8C4E37);
  static const Color softClay = Color(0xFFBF8D7A);
  static const Color crimsonRed = Color(0xFF8C0303);
  static const Color lightGray = Color(0xFFD9D9D9);
  static const Color colorBlue = Color(0xFF1CA6FC);
  static const Color colorOrange = Color(0xFFFFAB36);
  static const Color colorRed = Color(0xFFE3001A);
  static const Color intermediario = Color(0xFF0468BF);
  static const Color iniciante = Color(0xFF82CD00);
  static const Color avancado = Color(0xFFFAA234);
  static const Color virtuoso = Color(0xFFFF1434);

  static const Color colorWhite = Color(0xFFFFFFFF);

  // Novas cores baseadas na foto da Bíblia
  static const Color bibleGreen1 = Color(0xFF285954); // Verde musgo escuro
  static const Color bibleGreen2 = Color(0xFF86A694); // Verde musgo claro
  static const Color bibleGreen3 = Color(
    0xFF152610,
  ); // Verde floresta muito escuro
  static const Color bibleGreen4 = Color(0xFF25400B); // Verde floresta
  static const Color bibleGreen5 = Color(0xFF3B590C); // Verde folha

  // Cores de sombra/acento
  static const Color shadowTeal1 = Color(0xFF285954); // Igual ao bibleGreen1
  static const Color shadowTeal2 = Color(0xFF2AD1C0); // Turquesa brilhante
  static const Color shadowTeal3 = Color(0xFF32FCE8); // Turquesa neon
  static const Color shadowTeal4 = Color(0xFF23B0A2); // Turquesa médio
  static const Color shadowTeal5 = Color(0xFF1D8F83); // Turquesa escuro

  // Gradientes sugeridos
  static LinearGradient bibleBackgroundGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bibleGreen1, bibleGreen3],
  );

  static LinearGradient tealAccentGradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [shadowTeal4, shadowTeal2],
  );
}
