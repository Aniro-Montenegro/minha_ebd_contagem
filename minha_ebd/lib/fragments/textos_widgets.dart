import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minha_ebd/config/config_colors.dart';

class TextosWidget {
  static Widget tituloApp(String texto, {double? fontSize}) {
    return Text(
      texto,
      style: GoogleFonts.abrilFatface(
        fontSize: fontSize ?? 32,
        color: ConfigColors.bibleGreen2,
        letterSpacing: 1.5,
      ),
    );
  }

  static Widget tituloAppBar(String texto, {double? fontSize}) {
    return Text(
      texto,
      style: GoogleFonts.montserrat(
        fontSize: fontSize ?? 18,
        color: ConfigColors.lightGray,
        letterSpacing: 1.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget tituloSecao(String texto, {double? fontSize}) {
    return Text(
      texto,
      style: GoogleFonts.montserrat(
        fontSize: fontSize ?? 24,
        color: ConfigColors.mahogany,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  static Widget corpoTexto(
    String texto, {
    bool useRaleway = false,
    double? fontSize,
  }) {
    return Text(
      texto,
      style: (useRaleway ? GoogleFonts.raleway() : GoogleFonts.montserrat()),
    );
  }

  static Widget notaMusical(String texto, {double? fontSize}) {
    return Text(
      texto,
      style: GoogleFonts.robotoMono(
        fontSize: fontSize ?? 18,
        color: ConfigColors.softClay,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget destaque(String texto, {double? fontSize}) {
    return Text(
      texto,
      style: GoogleFonts.montserrat(
        fontSize: fontSize ?? 36,
        color: ConfigColors.crimsonRed,
        shadows: [
          Shadow(
            blurRadius: 2,
            offset: const Offset(1, 1),
            color: ConfigColors.lightGray.withAlpha(5),
          ),
        ],
      ),
    );
  }

  // Botões (Montserrat com contraste)
  static Widget textoBotao(String texto, {double? fontSize}) {
    return Text(
      texto,
      style: GoogleFonts.montserrat(
        fontSize: fontSize ?? 18,
        color: ConfigColors.lightGray,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }
}
