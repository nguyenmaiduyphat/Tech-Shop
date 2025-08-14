// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace, use_super_parameters, use_build_context_synchronously

import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tech_fun/utils/secure_storage_service.dart';
import 'package:tech_fun/views/main/layout_page.dart';

class InformPage extends StatefulWidget {
  const InformPage({super.key});

  @override
  State<InformPage> createState() => _InformPageState();
}

enum LoginSubPage { login, forgotPassword }

class _InformPageState extends State<InformPage> {
  final PageController _pageController = PageController();

  final TextEditingController _usernamecontroller_login = TextEditingController(
    text: '',
  );
  final TextEditingController _passwordcontroller_login = TextEditingController(
    text: '',
  );
  final TextEditingController _usernamecontroller_register =
      TextEditingController(text: '');
  final TextEditingController _passwordcontroller_register =
      TextEditingController(text: '');
  final TextEditingController _confirmpasswordcontroller_register =
      TextEditingController(text: '');
  final TextEditingController _emailcontroller_register = TextEditingController(
    text: '',
  );
  final TextEditingController _phonecontroller_register = TextEditingController(
    text: '',
  );
  final TextEditingController _addresscontroller_register =
      TextEditingController(text: '');
  final TextEditingController _birthcontroller_register = TextEditingController(
    text: '',
  );
  final TextEditingController _ciccontroller_register = TextEditingController(
    text: '',
  );
  final TextEditingController _bankcontroller_register = TextEditingController(
    text: '',
  );

  bool isLoginPage = true;
  bool readPolicy = false;
  String? selectedGender = "Male";
  LoginSubPage loginSubPage = LoginSubPage.login; // new

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
                  MaterialPageRoute(builder: (context) => LayoutPage()),
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

  Widget _buildForgotPasswordPage({Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Enter your email to reset your password',
            style: TextStyle(color: Colors.white70, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white10,
              prefixIcon: const Icon(Icons.email, color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.cyanAccent,
                  width: 2,
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          SizedBox(
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
                // Add reset logic here
              },
              child: const Text(
                'Reset Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 40),
          SizedBox(
            width: 200,
            height: 40,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  loginSubPage = LoginSubPage.login;
                });
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.cyanAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Back to Login',
                style: TextStyle(color: Colors.cyanAccent, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginContent({Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SlideInFromLeft(
                delay: const Duration(milliseconds: 100),
                child: _buildTextField(
                  controller: _usernamecontroller_login,
                  label: 'Username',
                  icon: Icons.person_outline,
                ),
              ),
              const SizedBox(height: 20),
              SlideInFromLeft(
                delay: const Duration(milliseconds: 200),
                child: _buildTextField(
                  controller: _passwordcontroller_login,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  obscure: true,
                ),
              ),
              const SizedBox(height: 30),
              SlideInFromLeft(
                delay: const Duration(milliseconds: 300),
                child: SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () async {
                      if (_usernamecontroller_login.text.contains(
                        '@gmail.com',
                      )) {
                        if (_usernamecontroller_login.text.split("@")[1] !=
                            "gmail.com") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "After @ of email must be gmail.com",
                              ),
                            ),
                          );
                          return;
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Your email must be email (@gmail.com)",
                            ),
                          ),
                        );
                        return;
                      }
                      // Login Success

                      await SecureStorageService.save(
                        SecureStorageService.keyName,
                        _usernamecontroller_login.text,
                      );

                      if (SecureStorageService.user == null) {
                        await SecureStorageService.save(
                          SecureStorageService.keyName,
                          SecureStorageService.offlineStatus,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Your email is not exist"),
                          ),
                        );
                        return;
                      } else {
                        setState(() {
                          SecureStorageService.currentUser =
                              _usernamecontroller_login.text;
                        });
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LayoutPage()),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SlideInFromLeft(
                delay: const Duration(milliseconds: 250),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      loginSubPage = LoginSubPage.forgotPassword;
                    });
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.white70,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SlideInFromLeft(
                delay: const Duration(milliseconds: 400),
                child: TextButton(
                  onPressed: _goToRegister,
                  child: const Text(
                    "Don't have an account? Register",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPage() {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < -500) {
            // Swipe Up
            if (loginSubPage == LoginSubPage.login) {
              setState(() => loginSubPage = LoginSubPage.forgotPassword);
            }
          } else if (details.primaryVelocity! > 500) {
            // Swipe Down
            if (loginSubPage == LoginSubPage.forgotPassword) {
              setState(() => loginSubPage = LoginSubPage.login);
            }
          }
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: Container(
          key: ValueKey(loginSubPage),
          width: double.infinity,
          height: MediaQuery.of(context).size.height, // make full height
          child: loginSubPage == LoginSubPage.login
              ? _buildLoginContent()
              : _buildForgotPasswordPage(),
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
          SlideInFromLeft(
            delay: const Duration(milliseconds: 100),
            child: _buildTextField(
              label: 'Username',
              icon: Icons.person,
              controller: _usernamecontroller_register,
            ),
          ),
          SlideInFromLeft(
            delay: const Duration(milliseconds: 200),
            child: _buildTextField(
              label: 'Password',
              icon: Icons.lock,
              obscure: true,
              controller: _passwordcontroller_register,
            ),
          ),
          SlideInFromLeft(
            delay: const Duration(milliseconds: 300),
            child: _buildTextField(
              label: 'Confirm Password',
              icon: Icons.lock_outline,
              obscure: true,
              controller: _confirmpasswordcontroller_register,
            ),
          ),
          SlideInFromLeft(
            delay: const Duration(milliseconds: 400),
            child: _buildTextField(
              label: 'Email',
              icon: Icons.email,
              controller: _emailcontroller_register,
            ),
          ),
          SlideInFromLeft(
            delay: const Duration(milliseconds: 500),
            child: _buildTextField(
              label: 'Phone Number',
              icon: Icons.phone,
              controller: _phonecontroller_register,
            ),
          ),
          SlideInFromLeft(
            delay: const Duration(milliseconds: 600),
            child: _buildTextField(
              label: 'Address',
              icon: Icons.home,
              controller: _addresscontroller_register,
            ),
          ),

          const SizedBox(height: 12),
          SlideInFromLeft(
            delay: const Duration(milliseconds: 700),
            child: DropdownButtonFormField<String>(
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
          ),
          const SizedBox(height: 12),
          SlideInFromLeft(
            delay: const Duration(milliseconds: 800),
            child: _buildTextField(
              label: 'Birthdate (YYYY-MM-DD)',
              icon: Icons.date_range,
              controller: _birthcontroller_register,
            ),
          ),
          SlideInFromLeft(
            delay: const Duration(milliseconds: 900),
            child: _buildTextField(
              label: 'Citizen Identification Card',
              icon: Icons.credit_card,
              controller: _ciccontroller_register,
            ),
          ),
          SlideInFromLeft(
            delay: const Duration(milliseconds: 1000),
            child: _buildTextField(
              label: 'Bank Account',
              icon: Icons.account_balance,
              controller: _bankcontroller_register,
            ),
          ),

          const SizedBox(height: 12),
          SlideInFromLeft(
            delay: const Duration(milliseconds: 1100),
            child: Row(
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
          ),

          const SizedBox(height: 24),
          SlideInFromLeft(
            delay: const Duration(milliseconds: 1200),
            child: Center(
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
                  onPressed: () async {
                    if (readPolicy) {
                      if (_usernamecontroller_register.text.isEmpty ||
                          _passwordcontroller_register.text.isEmpty ||
                          _confirmpasswordcontroller_register.text.isEmpty ||
                          _emailcontroller_register.text.isEmpty ||
                          _phonecontroller_register.text.isEmpty ||
                          _addresscontroller_register.text.isEmpty ||
                          _birthcontroller_register.text.isEmpty ||
                          _ciccontroller_register.text.isEmpty ||
                          _bankcontroller_register.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("You must fill all fields are empty"),
                          ),
                        );
                        return;
                      }

                      if (_emailcontroller_register.text.contains(
                        '@gmail.com',
                      )) {
                        if (_emailcontroller_register.text.split("@")[1] !=
                            "gmail.com") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "After @ of email must be gmail.com",
                              ),
                            ),
                          );
                          return;
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Your email must be email (@gmail.com)",
                            ),
                          ),
                        );
                        return;
                      }

                      if (_passwordcontroller_register.text.trim() ==
                          _confirmpasswordcontroller_register.text.trim()) {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: _emailcontroller_register.text,
                              password: _passwordcontroller_register.text,
                            );
                        _goToLogin();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Password and Confirm password are not matched",
                            ),
                          ),
                        );
                        return;
                      }
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
          ),
          SlideInFromLeft(
            delay: const Duration(milliseconds: 1300),
            child: Center(
              child: TextButton(
                onPressed: _goToLogin,
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
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
    required TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        cursorColor: const Color.fromARGB(255, 14, 167, 134),
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: _inputDecoration(label).copyWith(
          prefixIcon: icon != null ? Icon(icon, color: Colors.cyan) : null,
        ),
      ),
    );
  }
}

class SlideInFromLeft extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  const SlideInFromLeft({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOut,
  }) : super(key: key);

  @override
  State<SlideInFromLeft> createState() => _SlideInFromLeftState();
}

class _SlideInFromLeftState extends State<SlideInFromLeft>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // Delay before showing animation
    Timer(widget.delay, () {
      if (mounted) {
        setState(() => _visible = true);
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _visible
        ? SlideTransition(position: _animation, child: widget.child)
        : const SizedBox.shrink();
  }
}
