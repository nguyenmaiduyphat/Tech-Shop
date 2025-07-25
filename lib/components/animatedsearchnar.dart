import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatelessWidget {
  final Function(String) onSubmitted;

  const AnimatedSearchBar({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300),
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                cursorColor: const Color.fromARGB(255, 14, 167, 134),
                autofocus: true,
                onSubmitted: onSubmitted,
                textAlign: TextAlign.start, // ← align text to the left
                textAlignVertical:
                    TextAlignVertical.center, // ← vertical centering
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search Product...',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                  ), // ← add vertical padding
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
