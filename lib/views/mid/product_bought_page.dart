// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tech_fun/views/main/layout_page.dart';

class BoughtProduct {
  final String name;
  final double price;
  final String imageUrl;
  final String location;
  final double percentSale;
  final String ownerStore;

  BoughtProduct({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.location,
    required this.percentSale,
    required this.ownerStore,
  });
}

class ProductBoughtPage extends StatelessWidget {

  ProductBoughtPage({super.key});

  final List<BoughtProduct> boughtProducts = [
    BoughtProduct(
      name: 'Noise-Cancelling Headphones',
      price: 129.99,
      imageUrl: 'assets/product/product1.jpg',
      location: 'California',
      percentSale: 30,
      ownerStore: 'TechFun Audio',
    ),
    BoughtProduct(
      name: 'Ergonomic Running Shoes',
      price: 89.50,
      imageUrl: 'assets/product/product2.jpg',
      location: 'Texas',
      percentSale: 20,
      ownerStore: 'FitGear Pro',
    ),
    BoughtProduct(
      name: 'Curved 4K Monitor',
      price: 399.99,
      imageUrl: 'assets/product/product3.jpg',
      location: 'Oregon',
      percentSale: 25,
      ownerStore: 'UltraDisplay Inc',
    ),
    BoughtProduct(
      name: 'Bluetooth Speaker',
      price: 59.99,
      imageUrl: 'assets/product/product4.jpg',
      location: 'Nevada',
      percentSale: 15,
      ownerStore: 'SoundWorld',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                // Top Row with Title and Home Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: Colors.cyanAccent,
                      size: 30,
                    ),
                    Text(
                      'My Bought Products',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.home_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LayoutPage(),
                          ),
                        ); // Replace with your actual navigation
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Product List
                Expanded(
                  child: ListView.builder(
                    itemCount: boughtProducts.length,
                    itemBuilder: (context, i) {
                      final b = boughtProducts[i];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              b.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            b.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            '\$${b.price.toStringAsFixed(2)} • ${b.location} • ${b.percentSale}% off\nStore: ${b.ownerStore}',
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
