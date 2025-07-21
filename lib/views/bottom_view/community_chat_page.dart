import 'package:flutter/material.dart';

class CommunityChatPage extends StatefulWidget {
  const CommunityChatPage({super.key});

  @override
  State<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Community Chat Page',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}
