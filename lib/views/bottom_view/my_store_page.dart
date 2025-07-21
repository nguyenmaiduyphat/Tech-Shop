import 'package:flutter/material.dart';

class MyStorePage extends StatefulWidget {
  const MyStorePage({super.key});

  @override
  State<MyStorePage> createState() => _MyStorePageState();
}

class _MyStorePageState extends State<MyStorePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'My Store Page',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}
