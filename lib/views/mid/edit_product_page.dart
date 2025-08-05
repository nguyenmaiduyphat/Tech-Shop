// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_fun/views/main/layout_page.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController(
    text: 'Product 1',
  );
  final TextEditingController _priceController = TextEditingController(
    text: '100',
  );
  final TextEditingController _discountController = TextEditingController(
    text: '30',
  );
  final TextEditingController _ratingController = TextEditingController(
    text: '4.5',
  );
  final TextEditingController _soldController = TextEditingController(
    text: '45',
  );
  final TextEditingController _deliveryController = TextEditingController(
    text: '2',
  );

  String _location = 'TP.HCM';

  List<String> imagePaths = [
    'assets/product/product1.jpg',
    'assets/product/product2.jpg',
    'assets/product/product3.jpg',
  ];
  bool toggleGradient = true;

  List<Color> gradient1 = [
    Color(0xFF064663), // deep teal blue
    Color(0xFF0B3948), // dark blue gray
  ];

  List<Color> gradient2 = [
    Color(0xFF1A237E), // indigo dark
    Color(0xFF26C6DA), // cyan medium bright but not flashy
  ];

  @override
  void initState() {
    super.initState();
    // Start gradient animation loop
    Future.delayed(const Duration(milliseconds: 500), () {
      _startGradientLoop();
    });
  }

  void _startGradientLoop() {
    Timer.periodic(const Duration(seconds: 6), (_) {
      setState(() => toggleGradient = !toggleGradient);
    });
  }

  Color primaryHighlight = Color.fromARGB(255, 14, 167, 134); // tealish

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: toggleGradient ? gradient1 : gradient2,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                AppBar(
                  title: const Text("Edit Product"),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildForm(),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 12,
              right: 12,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LayoutPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.home, color: Colors.teal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(_nameController, 'Product Name'),
          _buildTextField(
            _priceController,
            'Price',
            keyboardType: TextInputType.number,
          ),
          _buildTextField(
            _discountController,
            'Discount (%)',
            keyboardType: TextInputType.number,
          ),
          _buildTextField(
            _ratingController,
            'Rating',
            keyboardType: TextInputType.number,
          ),
          _buildTextField(
            _soldController,
            'Sold',
            keyboardType: TextInputType.number,
          ),
          _buildTextField(
            _deliveryController,
            'Delivery (days)',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _location,
            dropdownColor: Colors.grey[850], // modern dark menu
            focusColor: Colors.transparent,
            iconEnabledColor: Colors.white70,
            decoration: InputDecoration(
              labelText: 'Location',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: const TextStyle(color: Colors.deepOrange),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryHighlight, width: 1.8),
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.12),
            ),
            onChanged: (val) => setState(() => _location = val!),
            style: const TextStyle(color: Colors.white),
            items: ['TP.HCM', 'Ha Noi', 'Da Nang']
                .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                .toList(),
          ),

          const SizedBox(height: 16),
          _buildImagePreview(),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product updated successfully')),
                );
              }
            },
            icon: const Icon(Icons.save),
            label: const Text(
              'Save Changes',
              style: TextStyle(color: Colors.deepOrange),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[700],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    final focusNode = FocusNode();

    return StatefulBuilder(
      builder: (context, setInnerState) {
        focusNode.addListener(() {
          setInnerState(() {});
        });

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: focusNode.hasFocus
                ? Colors.white
                : Colors.white70.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            focusNode: focusNode,
            controller: controller,
            keyboardType: keyboardType,
            cursorColor: primaryHighlight,
            decoration: InputDecoration(
              labelText: label,
              floatingLabelBehavior: FloatingLabelBehavior.always,

              labelStyle: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white60),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 14, 167, 134),
                  width: 1.8,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter $label';
              return null;
            },
          ),
        );
      },
    );
  }

  final ImagePicker _picker = ImagePicker();

  Widget _buildImagePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Images',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: imagePaths.length + 1, // +1 for "Add" button
            itemBuilder: (context, index) {
              if (index == imagePaths.length) {
                // Add Image Button
                return GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white24,
                      border: Border.all(color: Colors.white70),
                    ),
                    child: const Icon(Icons.add, size: 32, color: Colors.white),
                  ),
                );
              }

              final path = imagePaths[index];
              final isAsset = !path.startsWith(
                '/',
              ); // crude check for local file

              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: isAsset
                        ? Image.asset(
                            path,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          imagePaths.removeAt(index);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, _) => const SizedBox(width: 12),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePaths.add(image.path);
      });
    }
  }
}
