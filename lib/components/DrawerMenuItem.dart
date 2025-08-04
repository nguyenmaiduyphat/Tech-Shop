// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DrawerMenuItem(this.title, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
      onTap: onTap,
    );
  }
}
