import 'package:flutter/material.dart';
import 'package:tech_fun/models/order_detail.dart';
import 'package:tech_fun/views/mid/order_detail_page.dart';

class OrderTrackingPage extends StatefulWidget {
  final OrderDetail order;

  const OrderTrackingPage({super.key, required this.order});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTrackingPage> {
  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, size: 32, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailPage(order: widget.order),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Thông tin đơn hàng
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    "Order ID: ${order.id}",
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Customer: ${order.user}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "Date: ${order.dateCreated}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "Total: \$${order.total}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "Discount: ${order.discount}%",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "Status: ${order.status.name}",
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Tiêu đề
              const Text(
                "Delivery Stations",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              /// Timeline
              Expanded(
                child: ListView.builder(
                  itemCount: widget.order.address.length,
                  itemBuilder: (context, index) {
                    final station = widget.order.address[index];
                    final isLast = index == widget.order.address.length - 1;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Timeline dots
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: index <= order.status.index
                                      ? [Colors.cyanAccent, Colors.blueAccent]
                                      : [Colors.grey.shade600, Colors.grey],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  if (index <= order.status.index)
                                    BoxShadow(
                                      color: Colors.cyanAccent.withOpacity(0.6),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                ],
                              ),
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 60,
                                color: index < order.status.index
                                    ? Colors.cyanAccent
                                    : Colors.grey.shade700,
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),

                        /// Nội dung station
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white24,
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  station,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: index <= order.status.index
                                        ? Colors.white
                                        : Colors.white54,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  index == 0
                                      ? "Processing at warehouse"
                                      : index == widget.order.address.length - 1
                                      ? "Delivered to destination"
                                      : "In transit to next station",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
