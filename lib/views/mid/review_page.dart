import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tech_fun/models/product_detail.dart';
import 'package:tech_fun/models/review_detail.dart';
import 'package:tech_fun/utils/database_service.dart';
import 'package:tech_fun/utils/secure_storage_service.dart';
import 'package:tech_fun/views/main/layout_page.dart';
import 'package:tech_fun/views/mid/product_detail_page.dart';

class ReviewPage extends StatefulWidget {
  final ProductDetail product;
  const ReviewPage({super.key, required this.product});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<ReviewDetail> reviews = [];

  final TextEditingController _controller = TextEditingController();
  double _selectedRating = 0.0;

  void _addReview() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && _selectedRating > 0) {
      setState(() async {
        ReviewDetail review = ReviewDetail(
          idProduct: widget.product.id,
          content: text,
          rate: _selectedRating,
          image: widget.product.images[0],
          avatar: 'assets/user/user1.jpg',
          user: SecureStorageService.currentUser,
        );
        reviews.insert(0, review); // Add to top
        await FirebaseCloundService.addReview(review);
        _controller.clear();
        _selectedRating = 0.0; // reset after submit
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nội dung và chọn số sao.')),
      );
    }
  }

  Color _getBorderColor(double rate) {
    if (rate <= 1) return Colors.red;
    if (rate <= 2) return Colors.yellow;
    if (rate <= 3) return Colors.orange;
    if (rate <= 4) return Colors.blue;
    return Colors.green;
  }

  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
    }

    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 16));
    }

    while (stars.length < 5) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 16));
    }

    return Row(children: stars);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadDataFuture = loadData();
  }

  late Future<void> _loadDataFuture;

  Future<void> loadData() async {
    reviews = await FirebaseCloundService.getAllReviewsWithIdProduct(
      id: widget.product.id,
      amount: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF4F6FA), Color(0xFFE8ECF4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            FutureBuilder(
              future: _loadDataFuture,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (asyncSnapshot.hasError) {
                  return Center(child: Text('Lỗi: ${asyncSnapshot.error}'));
                } else {
                  return Column(
                    children: [
                      // Product Info Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                widget.product.images[0],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  buildStarRating(widget.product.rate),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      // Review List
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: const MaterialScrollBehavior().copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                          ),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: reviews.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: _getBorderColor(reviews[index].rate),
                                    width: 1.5,
                                  ),
                                ),
                                elevation: 2,
                                color: Colors.white.withOpacity(0.95),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Avatar
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                          reviews[index].avatar,
                                        ),
                                        radius: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      // Review content
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // User name and rating stars
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  reviews[index].user,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                _buildStarRating(
                                                  reviews[index].rate,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            // Review text
                                            Text(
                                              reviews[index].content,
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // Input Field
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, -3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ⭐ Star Rating Selector
                            Row(
                              children: List.generate(5, (index) {
                                final starIndex = index + 1;
                                return IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    _selectedRating >= starIndex
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedRating = starIndex.toDouble();
                                    });
                                  },
                                );
                              }),
                            ),
                            const SizedBox(height: 8),
                            // 📝 Text Input
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      hintText: 'Viết đánh giá của bạn...',
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _addReview,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueGrey[700],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  child: const Text('Gửi'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            // Home icon (top-right corner)
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 28,
                  color: Colors.blueGrey,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailPage(productDetail: widget.product),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor(); // Số sao đầy
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 20));
    }

    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 20));
    }

    while (stars.length < 5) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 20));
    }

    return Row(
      children: [
        ...stars,
        const SizedBox(width: 8),
        Text('$rating/5', style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
