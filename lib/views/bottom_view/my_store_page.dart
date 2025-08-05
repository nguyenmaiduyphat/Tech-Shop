// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:tech_fun/views/mid/edit_product_page.dart';
import 'package:tech_fun/views/mid/post_detail_page.dart';
import 'package:tech_fun/views/mid/post_store_page.dart';
import 'package:tech_fun/views/mid/product_bought_page.dart';
import 'package:tech_fun/views/mid/product_detail_page.dart';
import 'package:tech_fun/views/mid/product_store_page.dart';

class MyStorePage extends StatefulWidget {

  const MyStorePage({super.key});

  @override
  State<MyStorePage> createState() => _MyStorePageState();
}

class _MyStorePageState extends State<MyStorePage> {
  final List<Map<String, dynamic>> products = List.generate(
    10,
    (index) => {
      'name': 'Product $index',
      'price': (index + 1) * 10.0,
      'image': [
        'assets/product/product${(index % 3) + 1}.jpg',
        'assets/product/product${(index % 3) + 1}.jpg',
        'assets/product/product${(index % 3) + 1}.jpg',
        'assets/product/product${(index % 3) + 1}.jpg',
        'assets/product/product${(index % 3) + 1}.jpg',
        'assets/product/product${(index % 3) + 1}.jpg',
        'assets/product/product${(index % 3) + 1}.jpg',
        'assets/product/product${(index % 3) + 1}.jpg',
        'assets/product/product${(index % 3) + 1}.jpg',
      ],
    },
  );

  final List<Map<String, dynamic>> posts = List.generate(
    10,
    (index) => {
      'image': 'assets/product/product${(index % 3) + 1}.jpg',
      'title': 'Post Title $index',
    },
  );

  final List<Map<String, dynamic>> boughtProducts = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Store Info
              Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('assets/user/user1.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Your Store Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        'Owner: John Doe',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatBox('Orders Bought', '${boughtProducts.length}'),
                  _buildStatBox('Products', '${products.length}'),
                  _buildStatBox('Posts', '${posts.length}'),
                  _buildStatBox('Revenue', '\$5.2K'),
                ],
              ),
              const SizedBox(height: 24),

              // Your Products
              _buildSectionTitle('Your Products', () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductStorePage(),
                  ),
                );
              }),
              _buildProductList(products, emptyMessage: 'Upload your product'),

              const SizedBox(height: 16),

              // Your Posts
              _buildSectionTitle('Your Posts', () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PostStorePage(),
                  ),
                );
              }),
              _buildPostList(posts, emptyMessage: 'No posts yet'),

              const SizedBox(height: 16),

              // Bought Products
              _buildSectionTitle('Products Bought', () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductBoughtPage(),
                  ),
                );
              }),
              _buildProductList(
                boughtProducts,
                editable: false,
                emptyMessage: 'You haven’t bought anything yet',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        TextButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.add, color: Colors.white70),
          label: const Text('More', style: TextStyle(color: Colors.white70)),
        ),
      ],
    );
  }

  Widget _buildProductList(
    List<Map<String, dynamic>> list, {
    bool editable = true,
    required String emptyMessage,
  }) {
    return list.isEmpty
        ? Center(
            child: Text(
              emptyMessage,
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
          )
        : AnimationList(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            duration: 600,
            animationDirection: AnimationDirection.vertical,
            children: list.take(5).map((item) {
              int index = list.indexOf(item);
              return Card(
                color: const Color(0xFF1F1F2E),
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 6,
                shadowColor: Colors.black45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      item['image'][0],
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    item['name'] ?? item['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: item['price'] != null
                      ? Text(
                          '\$${item['price']}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        )
                      : null,
                  trailing: GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      _showItemOptions(
                        context: context,
                        offset: details.globalPosition,
                        index: index,
                        list: list,
                        isPost: false,
                        item: item,
                      );
                    },
                    child: const Icon(Icons.more_vert, color: Colors.white70),
                  ),
                ),
              );
            }).toList(),
          );
  }

  Widget _buildPostList(
    List<Map<String, dynamic>> list, {
    required String emptyMessage,
  }) {
    return list.isEmpty
        ? Center(
            child: Text(
              emptyMessage,
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
          )
        : AnimationList(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            duration: 600,
            animationDirection: AnimationDirection.vertical,
            children: list.take(5).map((item) {
              int index = list.indexOf(item);
              return Card(
                color: const Color(0xFF1F1F2E),
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item['image'],
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          _showItemOptions(
                            context: context,
                            offset: details.globalPosition,
                            index: index,
                            list: list,
                            isPost: true,
                            item: item,
                          );
                        },
                        child: const Icon(
                          Icons.more_vert,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
  }

  void _showItemOptions({
    required BuildContext context,
    required Offset offset,
    required int index,
    required List<Map<String, dynamic>> list,
    required Map<String, dynamic> item,
    required bool isPost,
  }) async {
    final Size screenSize = MediaQuery.of(context).size;
    const double menuWidth = 160;
    double left = offset.dx;
    double right = screenSize.width - left - menuWidth;

    if (right < 16) {
      left = screenSize.width - menuWidth - 16;
    }

    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(left, offset.dy, 0, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF1C1C1E),
      elevation: 12,
      items: isPost
          ? [
              _buildHoverMenuItem(
                value: 'remove',
                label: '🗑️ Remove',
                onPressed: () {},
              ),
              _buildHoverMenuItem(
                value: 'view',
                label: '👁️ View Detail',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostDetailPage(),
                    ),
                  );
                },
              ),
            ]
          : [
              _buildHoverMenuItem(
                value: 'remove',
                label: '🗑️ Remove',
                onPressed: () {},
              ),
              _buildHoverMenuItem(
                value: 'edit',
                label: '✏️ Edit',
                onPressed: () {},
              ),
              _buildHoverMenuItem(
                value: 'view',
                label: '👁️ View Detail',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        imageGallery: item['image'],
                      ),
                    ),
                  );
                },
              ),
            ],
    );

    if (result == 'remove') {
      setState(() {
        list.removeAt(index);
      });
    } else if (result == 'edit') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Edit clicked')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EditProductPage(),
        ),
      );
    } else if (result == 'view') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('View Detail clicked')));
    }
  }

  PopupMenuItem<String> _buildHoverMenuItem({
    required String value,
    required String label,
    required VoidCallback onPressed,
  }) {
    bool isHovered = false;
    return PopupMenuItem<String>(
      padding: EdgeInsets.zero,
      value: value,
      child: StatefulBuilder(
        builder: (context, setState) {
          return MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            cursor: SystemMouseCursors.click,
            child: TextButton(
              onPressed: onPressed,
              child: Text(
                label,
                style: TextStyle(
                  color: isHovered ? Colors.deepOrange : Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
