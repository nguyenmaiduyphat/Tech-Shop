import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tech_fun/models/user_detail.dart';
import 'package:tech_fun/utils/database_service.dart';
import 'package:tech_fun/utils/secure_storage_service.dart';
import 'package:tech_fun/views/main/layout_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  bool _isEditing = false;
  bool _hasChanges = false;

  TextEditingController _usernameController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _phoneController = TextEditingController(text: '');
  TextEditingController _addressController = TextEditingController(text: '');
  TextEditingController _citizenIdController = TextEditingController(text: '');
  TextEditingController _bankAccountController = TextEditingController(
    text: '',
  );
  TextEditingController _birthdateController = TextEditingController(text: '');

  String gender = 'Male';

  late Map<String, dynamic> _initialValues;

  @override
  void initState() {
    super.initState();
    _setInitialValues(); // Format birthdate to string

    if (SecureStorageService.user != null) {
      _usernameController = TextEditingController(
        text: SecureStorageService.user!.username,
      );
      _passwordController = TextEditingController(
        text: SecureStorageService.user!.password,
      );
      _emailController = TextEditingController(
        text: SecureStorageService.user!.email,
      );
      _phoneController = TextEditingController(
        text: SecureStorageService.user!.phone,
      );
      _addressController = TextEditingController(
        text: SecureStorageService.user!.address,
      );
      _citizenIdController = TextEditingController(
        text: SecureStorageService.user!.CIC,
      );
      _bankAccountController = TextEditingController(
        text: SecureStorageService.user!.bankNumber,
      );
      _birthdateController = TextEditingController(
        text: SecureStorageService.user!.birth,
      );
      gender = SecureStorageService.user!.gender;
    }
  }

  Future<void> _setInitialValues() async {
    _initialValues = {
      'username': _usernameController.text,
      'password': _passwordController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'citizenId': _citizenIdController.text,
      'bankAccount': _bankAccountController.text,
      'gender': gender,
      'birthdate': _birthdateController.text,
    };

    await FirebaseCloundService.updateUser(
      UserDetail(
        username: _usernameController.text,
        password: _passwordController.text,
        email: SecureStorageService.user!.email,
        phone: _phoneController.text,
        address: _addressController.text,
        gender: gender,
        birth: _birthdateController.text,
        CIC: _citizenIdController.text,
        bankNumber: _bankAccountController.text,
      ),
    );
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
          gender != _initialValues['gender'] ||
          _birthdateController.text != _initialValues['birthdate'];
    });
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
        gender = _initialValues['gender'];
        _birthdateController.text = _initialValues['birthdate'];
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
                  MaterialPageRoute(builder: (context) => LayoutPage()),
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
                  value: gender,
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
                            gender = value!;
                            _checkForChanges();
                          });
                        }
                      : null,
                ),
                const SizedBox(height: 12),

                _buildTextField('Birth', controller: _birthdateController),

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
