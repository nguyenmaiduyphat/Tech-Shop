import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tech_fun/models/order_detail.dart';
import 'package:tech_fun/utils/formatcurrency.dart';
import 'package:tech_fun/views/main/layout_page.dart';
import 'package:tech_fun/views/mid/order_page.dart';

class OrderDetailPage extends StatefulWidget {
  final OrderDetail order;

  const OrderDetailPage({super.key, required this.order});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<Color?> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _gradientAnimation = ColorTween(
      begin: const Color(0xFF0F2027),
      end: const Color(0xFF2C5364),
    ).animate(_gradientController);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  Color _statusColor(StatusOrder status) {
    switch (status) {
      case StatusOrder.Processing:
        return Colors.orangeAccent;
      case StatusOrder.Shipped:
        return Colors.lightBlueAccent;
      case StatusOrder.Delivered:
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(StatusOrder status) {
    switch (status) {
      case StatusOrder.Processing:
        return Icons.sync;
      case StatusOrder.Shipped:
        return Icons.local_shipping;
      case StatusOrder.Delivered:
        return Icons.check_circle;
      default:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return AnimatedBuilder(
      animation: _gradientAnimation,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _gradientAnimation.value ?? Colors.black,
                  Colors.black,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AppBar
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => OrderPage()),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order ID: ${order.id}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat(
                                  'yyyy-MM-dd',
                                ).format(DateTime.parse(order.dateCreated)),
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _statusIcon(order.status),
                          color: _statusColor(order.status),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          order.status.name,
                          style: TextStyle(
                            color: _statusColor(order.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      "Order Items",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Scrollable list
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: ScrollConfiguration(
                              behavior: const MaterialScrollBehavior().copyWith(
                                dragDevices: {
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.mouse,
                                },
                              ),
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                itemCount: order.items.length,
                                itemBuilder: (context, index) {
                                  final entry = order.items.entries.elementAt(
                                    index,
                                  );
                                  final product = entry.key;
                                  final quantity = entry.value;

                                  return ListTile(
                                    leading: const Icon(
                                      Icons.memory,
                                      color: Colors.white38,
                                    ),
                                    title: Text(
                                      product.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Qty: $quantity",
                                      style: const TextStyle(
                                        color: Colors.white54,
                                      ),
                                    ),
                                    trailing: Text(
                                      formatCurrency(product.price * quantity),
                                      style: const TextStyle(
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Summary
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.white24)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Discount:",
                                style: TextStyle(color: Colors.white60),
                              ),
                              Text(
                                "-${order.discount}%",
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formatCurrency(
                                  (order.total - order.discount).toInt(),
                                ),
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Track Order Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Tracking not yet implemented"),
                            ),
                          );
                        },
                        icon: const Icon(Icons.location_on),
                        label: const Text("Track Order"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent.withOpacity(0.8),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 8,
                          shadowColor: Colors.cyanAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
