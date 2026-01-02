import 'package:flutter/material.dart';
import 'package:minha_ebd/pages/home_page.dart';
import 'package:minha_ebd/services/navigato_to_page.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? destination;

  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          NavigateToPage.toWidget(context, destination ?? HomePage());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
