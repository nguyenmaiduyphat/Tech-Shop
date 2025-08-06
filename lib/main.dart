import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech_fun/firebase_options.dart';
import 'package:tech_fun/models/product_detail.dart';
import 'package:tech_fun/utils/database_service.dart';
import 'package:tech_fun/utils/secure_storage_service.dart';
import 'package:tech_fun/views/main/layout_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SecureStorageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: LayoutPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
