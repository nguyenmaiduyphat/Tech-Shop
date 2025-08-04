import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_fun/views/main/layout_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Fun',
      theme: ThemeData(
        textTheme: GoogleFonts.tekturTextTheme(), // 👈 Global Poppins font
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true, // Optional for modern styling
      ),
      home: LayoutPage(isLoggedIn: isLoggedIn),
      debugShowCheckedModeBanner: false,
    );
  }
}
