import 'package:flutter/material.dart';

class HoverButton extends StatefulWidget {
  final String label;
  final Color color;
  final Color hoverColor;
  final VoidCallback onPressed;

  const HoverButton({
    required this.label,
    required this.color,
    required this.hoverColor,
    required this.onPressed,
  });

  @override
  State<HoverButton> createState() => HoverButtonState();
}

class HoverButtonState extends State<HoverButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isHovered ? widget.hoverColor : widget.color,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 3,
        ),
        onPressed: widget.onPressed,
        child: Text(widget.label),
      ),
    );
  }
}
