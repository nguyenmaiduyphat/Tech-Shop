import 'package:flutter/material.dart';

class HeaderMenuItem extends StatelessWidget {
  final String title;

  const HeaderMenuItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          title,
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      ),
    );
  }
}
