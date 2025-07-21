import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final String rank;
  const UserAvatar({super.key, required this.name, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.orange,
          child: Text(
            name.isNotEmpty ? name[0] : "?",
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(rank, style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
