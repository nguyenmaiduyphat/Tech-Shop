import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tech_fun/views/main/layout_page.dart';

class ProfilePage extends StatefulWidget {
  final bool isLoggedIn;

  const ProfilePage({super.key, required this.isLoggedIn});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  bool _isEditing = false;
  bool _hasChanges = false;

  final TextEditingController _usernameController = TextEditingController(
    text: 'john_doe',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: 'password123',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'john@example.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '0123456789',
  );
  final TextEditingController _addressController = TextEditingController(
    text: '123 Main Street',
  );
  final TextEditingController _citizenIdController = TextEditingController(
    text: '1234567890123',
  );
  final TextEditingController _bankAccountController = TextEditingController(
    text: '9876543210',
  );
  final TextEditingController _birthdateController = TextEditingController();

  String? _gender = 'Male';
  DateTime? _birthdate = DateTime(1990, 1, 1);

  late Map<String, dynamic> _initialValues;

  @override
  void initState() {
    super.initState();
    _setInitialValues(); // Format birthdate to string
    if (_birthdate != null) {
      _birthdateController.text =
          '${_birthdate!.day.toString().padLeft(2, '0')}/${_birthdate!.month.toString().padLeft(2, '0')}/${_birthdate!.year}';
    }
  }

  void _setInitialValues() {
    _initialValues = {
      'username': _usernameController.text,
      'password': _passwordController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'citizenId': _citizenIdController.text,
      'bankAccount': _bankAccountController.text,
      'gender': _gender,
      'birthdate': _birthdate,
    };
  }

  void _checkForChanges() {
    setState(() {
      _hasChanges =
          _usernameController.text != _initialValues['username'] ||
          _passwordController.text != _initialValues['password'] ||
          _phoneController.text != _initialValues['phone'] ||
          _addressController.text != _initialValues['address'] ||
          _citizenIdController.text != _initialValues['citizenId'] ||
          _bankAccountController.text != _initialValues['bankAccount'] ||
          _gender != _initialValues['gender'] ||
          _birthdate != _initialValues['birthdate'];
    });
  }

  Future<void> _pickBirthdate() async {
    if (!_isEditing) return;
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthdate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdate = picked;
        _birthdateController.text =
            '${_birthdate!.day.toString().padLeft(2, '0')}/${_birthdate!.month.toString().padLeft(2, '0')}/${_birthdate!.year}';
        _checkForChanges();
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        // Cancel editing
        _usernameController.text = _initialValues['username'];
        _passwordController.text = _initialValues['password'];
        _phoneController.text = _initialValues['phone'];
        _addressController.text = _initialValues['address'];
        _citizenIdController.text = _initialValues['citizenId'];
        _bankAccountController.text = _initialValues['bankAccount'];
        _gender = _initialValues['gender'];
        _birthdate = _initialValues['birthdate'];
        _hasChanges = false;
      }
      _isEditing = !_isEditing;
    });
  }

  void _applyChanges() {
    if (_formKey.currentState!.validate()) {
      _setInitialValues();
      setState(() {
        _isEditing = false;
        _hasChanges = false;
      });
    }
  }

  Widget _buildTextField(
    String label, {
    required TextEditingController controller,
    bool readOnly = false,
    bool obscure = false,
    TextInputType? inputType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      readOnly: !_isEditing || readOnly,
      keyboardType: inputType,
      onChanged: (_) => _checkForChanges(),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.grey[900],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LayoutPage(isLoggedIn: widget.isLoggedIn),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            const Text('Profile', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit,
              color: Colors.white,
            ),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/avatar.png'),
                        backgroundColor: Colors.grey,
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _buildTextField('Username', controller: _usernameController),
                const SizedBox(height: 12),
                _buildTextField(
                  'Password',
                  controller: _passwordController,
                  obscure: true,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Email',
                  controller: _emailController,
                  readOnly: true,
                ),
                const SizedBox(height: 12),
                _buildTextField('Phone Number', controller: _phoneController),
                const SizedBox(height: 12),
                _buildTextField('Address', controller: _addressController),
                const SizedBox(height: 12),
                _buildTextField('Citizen ID', controller: _citizenIdController),
                const SizedBox(height: 12),
                _buildTextField(
                  'Bank Account',
                  controller: _bankAccountController,
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  dropdownColor: Colors.grey[900],
                  value: _gender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    labelStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[900],
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Male',
                      child: Text(
                        'Male',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Female',
                      child: Text(
                        'Female',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Other',
                      child: Text(
                        'Other',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  onChanged: _isEditing
                      ? (value) {
                          setState(() {
                            _gender = value;
                            _checkForChanges();
                          });
                        }
                      : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _birthdateController,
                  readOnly: true,
                  onTap: _pickBirthdate,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Birthdate',
                    labelStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[900],
                    suffixIcon: _isEditing
                        ? const Icon(Icons.calendar_today, color: Colors.white)
                        : null,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (_isEditing)
                  ElevatedButton(
                    onPressed: _hasChanges ? _applyChanges : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[850],
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[700],
                    ),
                    child: const Text('Apply Changes'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
