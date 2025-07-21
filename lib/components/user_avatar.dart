import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final String rank;
  final VoidCallback onTap;

  const UserAvatar({
    super.key,
    required this.name,
    required this.rank,
    required this.onTap,
  });

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
        Expanded(
          child: Column(
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
        ),
        IconButton(
          onPressed: onTap,
          icon: Icon(Icons.logout, color: Colors.red),
        ),
      ],
    );
  }
}
