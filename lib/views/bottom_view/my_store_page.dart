// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:tech_fun/models/post_info.dart';
import 'package:tech_fun/models/product_detail.dart';
import 'package:tech_fun/models/shop_detail.dart';
import 'package:tech_fun/utils/database_service.dart';
import 'package:tech_fun/utils/formatcurrency.dart';
import 'package:tech_fun/utils/secure_storage_service.dart';
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
  List<ProductDetail> productList = [];
  final List<Map<String, dynamic>> boughtProducts = [];
  ShopDetail? myShop;
  List<PostInfo>? postList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDataFuture = loadData();
  }

  late Future<void> _loadDataFuture;

  Future<void> loadData() async {
    productList = await FirebaseCloundService.getAllProducts();
    if (SecureStorageService.user != null) {
      myShop = await FirebaseCloundService.getShopById(
        SecureStorageService.user!.email,
      );

      postList = await FirebaseCloundService.getAllPostsWithEmail(
        SecureStorageService.user!.email,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadDataFuture,
      builder: (context, asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading....');
          default:
            if (asyncSnapshot.hasError) {
              return Text('Error: ${asyncSnapshot.error}');
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ScrollConfiguration(
                  behavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
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
                              backgroundImage: AssetImage(
                                'assets/user/user1.jpg',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  myShop == null
                                      ? 'Your Store Name'
                                      : myShop!.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  'Owner: ${SecureStorageService.user == null ? 'Guest' : SecureStorageService.user!.username}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
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
                            _buildStatBox(
                              'Orders Bought',
                              myShop == null
                                  ? '0'
                                  : myShop!.orderBoughtTotal.toString(),
                            ),
                            _buildStatBox(
                              'Products',
                              myShop == null
                                  ? '0'
                                  : myShop!.productTotal.toString(),
                            ),
                            _buildStatBox(
                              'Posts',
                              myShop == null
                                  ? '0'
                                  : myShop!.postTotal.toString(),
                            ),
                            _buildStatBox(
                              'Revenue',
                              myShop == null
                                  ? '0'
                                  : myShop!.revenueTotal.toString(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Your Products
                        _buildSectionTitle('Your Products', () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductStorePage(),
                            ),
                          );
                        }),
                        _buildProductList(
                          productList,
                          emptyMessage: 'Upload your product',
                        ),

                        const SizedBox(height: 16),

                        // Your Posts
                        _buildSectionTitle('Your Posts', () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostStorePage(),
                            ),
                          );
                        }),
                        _buildPostList(
                          postList ?? [],
                          emptyMessage: 'No posts yet',
                        ),

                        const SizedBox(height: 16),

                        // Bought Products
                        _buildSectionTitle('Products Bought', () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductBoughtPage(),
                            ),
                          );
                        }),
                        _buildProductList(
                          productList,
                          editable: false,
                          emptyMessage: 'You haven’t bought anything yet',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        }
      },
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
    List<ProductDetail> list, {
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
                      item.images[0],
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    formatCurrency(item.price),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  trailing: GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      _showItemOptions(
                        context: context,
                        offset: details.globalPosition,
                        index: index,
                        list: productList,
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

  Widget _buildPostList(List<PostInfo> list, {required String emptyMessage}) {
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
                          item.imageContent[0],
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          // _showItemOptions(
                          //   context: context,
                          //   offset: details.globalPosition,
                          //   index: index,
                          //   list: list,
                          //   isPost: true,
                          //   item: item,
                          // );
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
    required List<ProductDetail> list,
    required ProductDetail item,
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
                      builder: (context) =>
                          ProductDetailPage(productDetail: item),
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
        MaterialPageRoute(builder: (context) => EditProductPage()),
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
