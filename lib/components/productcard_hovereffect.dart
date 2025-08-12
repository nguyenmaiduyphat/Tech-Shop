// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tech_fun/models/product_detail.dart';
import 'package:tech_fun/utils/formatcurrency.dart';
import 'package:tech_fun/views/mid/product_detail_page.dart';

class ProductCardHoverEffect extends StatefulWidget {
  final ProductDetail product;

  const ProductCardHoverEffect({super.key, required this.product});

  @override
  State<ProductCardHoverEffect> createState() => _ProductCardHoverEffectState();
}

class _ProductCardHoverEffectState extends State<ProductCardHoverEffect> {
  double _scale = 1.0;
  bool isHovered = false;

  void _onEnter(_) {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      setState(() {
        _scale = 0.97;
        isHovered = true;
      });
    }
  }

  void _onExit(_) {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      setState(() {
        _scale = 1;
        isHovered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 400 ? screenWidth * 0.75 : 160.0;

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailPage(productDetail: widget.product),
              ),
            );
          },
          child: SizedBox(
            width: cardWidth,
            child: Card(
              color: Colors.transparent,
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0F2027),
                      Color(0xFF203A43),
                      Color(0xFF2C5364),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🖼️ Image
                      Expanded(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              widget.product.images[0],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// 🏷️ Product Name
                      Text(
                        widget.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isHovered ? Colors.deepOrange : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// 💰 Price + Discount
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              formatCurrency(widget.product.price),
                              style: TextStyle(
                                color: isHovered
                                    ? Colors.deepOrange
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (widget.product.discount != 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '-${widget.product.discount.toString()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// ⭐ Rating + 🛒 Sold
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.product.rate.toStringAsFixed(1)}',
                            style: TextStyle(
                              color: isHovered
                                  ? Colors.deepOrange
                                  : Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '${widget.product.solds.toString()} sold',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isHovered
                                    ? Colors.deepOrange
                                    : Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// 📍 Delivery + Location
                      Row(
                        children: [
                          Icon(
                            Icons.delivery_dining_sharp,
                            color: Colors.green[800],
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.product.deliveryDays.toString()} ${widget.product.deliveryDays > 1 ? 'days' : 'day'}',
                            style: TextStyle(
                              color: isHovered
                                  ? Colors.deepOrange
                                  : Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "|",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.location_on,
                            color: Colors.white70,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              widget.product.location,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isHovered
                                    ? Colors.deepOrange
                                    : Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
