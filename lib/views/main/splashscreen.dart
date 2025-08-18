import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tech_fun/views/main/layout_page.dart';
import 'package:zo_animated_border/zo_animated_border.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );

    _controller.forward();

    // Navigate to the main layout page after delay
    Timer(const Duration(seconds: 10), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LayoutPage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Tech-themed background
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tech logo animation
              ZoAnimatedGradientBorder(
                borderRadius: 70, // circle
                borderThickness: 4,
                gradientColor: [
                  Colors.cyanAccent,
                  Colors.blueAccent,
                  Colors.purpleAccent,
                ],
                duration: const Duration(seconds: 4),
                child: Container(
                  width: 140,
                  height: 140,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F172A), // match splash background
                    shape: BoxShape.circle,
                  ),
                  child: Lottie.asset(
                    'assets/animation/tech-logo.json',
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.memory,
                      size: 60,
                      color: Colors.cyanAccent,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              // App title
              Text(
                'Tech Fun',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,

                  shadows: [
                    Shadow(
                      color: Colors.cyanAccent.withOpacity(0.7),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
