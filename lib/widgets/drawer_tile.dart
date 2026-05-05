import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label),
      onTap: () {
        Navigator.pop(context); // Siempre cerramos el drawer al presionar
        if (onTap != null) onTap!();
      },
    );
  }
}
