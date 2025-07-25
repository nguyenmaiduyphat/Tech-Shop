import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech_fun/views/main/layout_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Home Page',
      theme: ThemeData(
        textTheme: GoogleFonts.tekturTextTheme(), // 👈 Global Poppins font
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true, // Optional for modern styling
      ),
      home: LayoutPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
//Tektur