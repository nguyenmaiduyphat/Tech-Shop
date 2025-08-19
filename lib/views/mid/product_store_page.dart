// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tech_fun/views/main/layout_page.dart';

class Product {
  final String name;
  final double price;
  final String imageUrl;
  final String location;
  final double percentSale;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.location,
    required this.percentSale,
  });
}

class ProductStorePage extends StatefulWidget {
  const ProductStorePage({super.key});

  @override
  State<ProductStorePage> createState() => _ProductStorePageState();
}

class _ProductStorePageState extends State<ProductStorePage> {
  final List<Product> products = [
    Product(
      name: 'Ultra HD 4K Android Smartphone with AI Camera',
      price: 299.99,
      imageUrl: 'assets/product/product1.jpg',
      location: 'New York',
      percentSale: 50,
    ),
    Product(
      name: 'Wireless Noise-Cancelling Over-Ear Headphones Pro Edition',
      price: 129.99,
      imageUrl: 'assets/product/product1.jpg',
      location: 'California',
      percentSale: 50,
    ),
    Product(
      name: 'Ergonomic Running Shoes with Memory Foam Sole',
      price: 89.50,
      imageUrl: 'assets/product/product1.jpg',
      location: 'Texas',
      percentSale: 50,
    ),
    Product(
      name: 'Smartwatch with GPS, Heart Rate, and Sleep Tracking',
      price: 149.99,
      imageUrl: 'assets/product/product1.jpg',
      location: 'Florida',
      percentSale: 50,
    ),
    Product(
      name: 'Bluetooth Portable Speaker with 360° Surround Sound',
      price: 59.99,
      imageUrl: 'assets/product/product1.jpg',
      location: 'Nevada',
      percentSale: 50,
    ),
    Product(
      name: 'Convertible Laptop with Touchscreen and Stylus Pen',
      price: 749.00,
      imageUrl: 'assets/product/product1.jpg',
      location: 'Washington',
      percentSale: 50,
    ),
    Product(
      name: 'Professional DSLR Camera with 24.2MP Sensor and WiFi',
      price: 899.00,
      imageUrl: 'assets/product/product1.jpg',
      location: 'Illinois',
      percentSale: 50,
    ),
    Product(
      name: 'Gaming Mouse with RGB Lighting and Adjustable DPI',
      price: 39.99,
      imageUrl: 'assets/product/product1.jpg',
      location: 'Georgia',
      percentSale: 50,
    ),
    Product(
      name: 'Smart Home Assistant with Voice Recognition & AI',
      price: 119.99,
      imageUrl: 'assets/product/product1.jpg',
      location: 'Colorado',
      percentSale: 50,
    ),
    Product(
      name: '4K Curved Gaming Monitor with 144Hz Refresh Rate',
      price: 399.99,
      imageUrl: 'assets/product/product1.jpg',
      location: 'Oregon',
      percentSale: 50,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Stack(
            children: [
              Column(
                children: [
                  const Text(
                    'Product Store',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowHeight: 56,
                            dataRowHeight: 80,
                            columnSpacing: 32,
                            headingRowColor: MaterialStateProperty.all(
                              Colors.blueGrey.shade900.withOpacity(0.8),
                            ),
                            dataRowColor:
                                MaterialStateProperty.resolveWith<Color?>((
                                  Set<MaterialState> states,
                                ) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.blueGrey.shade700.withOpacity(
                                      0.5,
                                    );
                                  }
                                  return null;
                                }),
                            columns: const [
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    'Image',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    'Price',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    'Location',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    'Sale',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                // New Edit column
                                label: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows: products.map((product) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          product.imageUrl,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        product.name.length > 20
                                            ? '${product.name.substring(0, 20)}...'
                                            : product.name,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        product.location,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${product.percentSale}%',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    // Edit Icon
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.orangeAccent,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ), // Home icon at top-right corner
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 35),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LayoutPage(),
                      ),
                    );
                  },
                ),
              ),

              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.add_box_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    _showAddProductDialog();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Add Product',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Product Name',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Price',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locationController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Location',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                final name = nameController.text.trim();
                final priceText = priceController.text.trim();
                final location = locationController.text.trim();

                if (name.isNotEmpty &&
                    priceText.isNotEmpty &&
                    location.isNotEmpty) {
                  final price = double.tryParse(priceText) ?? 0.0;
                  setState(() {
                    products.add(
                      Product(
                        name: name,
                        price: price,
                        location: location,
                        imageUrl: 'assets/product/product1.jpg',
                        percentSale: 0,
                      ),
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
