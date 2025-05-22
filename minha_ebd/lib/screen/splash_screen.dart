import 'package:flutter/material.dart';
import 'package:minha_ebd/config/config_colors.dart';

class SplashScreen extends StatelessWidget {
  final Duration duration;
  final Widget nextScreen;

  const SplashScreen({
    super.key,
    required this.duration,
    required this.nextScreen,
  });

  @override
  Widget build(BuildContext context) {
    Future.delayed(duration, () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => nextScreen));
    });

    return Scaffold(
      backgroundColor: ConfigColors.bibleGreen2,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset(
              'imagens/icone.png',
              fit: BoxFit.contain,

              errorBuilder:
                  (context, error, stackTrace) =>
                      Container(color: ConfigColors.bibleGreen2),
            ),
          ),
        ],
      ),
    );
  }
}
