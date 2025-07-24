import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tech_fun/views/main/layout_page.dart';

class InformPage extends StatefulWidget {
  const InformPage({super.key});

  @override
  State<InformPage> createState() => _InformPageState();
}

class _InformPageState extends State<InformPage> {
  final PageController _pageController = PageController();
  bool isLoginPage = true;
  bool readPolicy = false;
  String? selectedGender;

  void _goToRegister() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() => isLoginPage = false);
  }

  void _goToLogin() {
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() => isLoginPage = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Animated Background
          AnimatedContainer(
            duration: const Duration(seconds: 3),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
            ),
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) =>
                  setState(() => isLoginPage = index == 0),
              children: [_buildLoginPage(), _buildRegisterPage()],
            ),
          ),

          // Home icon top right
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.home, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LayoutPage()),
                );
              },
            ),
          ),

          // Logo + Text Center Top
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Lottie.asset(
                    'assets/animation/EngineToolShape.json',
                    repeat: true,
                    animate: true,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Tech Fun",
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.blueAccent, blurRadius: 8)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(label: 'Username', icon: Icons.person_outline),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Password',
                icon: Icons.lock_outline,
                obscure: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextButton(
                onPressed: _goToRegister,
                child: const Text(
                  "Don't have an account? Register",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(label: 'Username', icon: Icons.person),
          _buildTextField(label: 'Password', icon: Icons.lock, obscure: true),
          _buildTextField(
            label: 'Confirm Password',
            icon: Icons.lock_outline,
            obscure: true,
          ),
          _buildTextField(label: 'Email', icon: Icons.email),
          _buildTextField(label: 'Phone Number', icon: Icons.phone),
          _buildTextField(label: 'Address', icon: Icons.home),

          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedGender,
            dropdownColor: Colors.grey.shade900,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Gender"),
            items: const [
              DropdownMenuItem(value: "Male", child: Text("Male")),
              DropdownMenuItem(value: "Female", child: Text("Female")),
              DropdownMenuItem(value: "Other", child: Text("Other")),
            ],
            onChanged: (value) => setState(() => selectedGender = value),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Birthdate (YYYY-MM-DD)',
            icon: Icons.date_range,
          ),
          _buildTextField(
            label: 'Citizen Identification Card',
            icon: Icons.credit_card,
          ),
          _buildTextField(label: 'Bank Account', icon: Icons.account_balance),

          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: readPolicy,
                activeColor: Colors.blueAccent,
                onChanged: (value) =>
                    setState(() => readPolicy = value ?? false),
              ),
              const Expanded(
                child: Text(
                  "I accept the policy and terms",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  if (readPolicy) {
                    // Register logic
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You must accept the policy"),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Register",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: _goToLogin,
            child: const Text(
              "Already have an account? Login",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white10,
      prefixIconColor: Colors.cyan,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.blueAccent.shade100, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.blueAccent.shade100, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    IconData? icon,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: _inputDecoration(label).copyWith(
          prefixIcon: icon != null ? Icon(icon, color: Colors.cyan) : null,
        ),
      ),
    );
  }
}
