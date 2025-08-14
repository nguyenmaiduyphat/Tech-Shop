import 'package:flutter/material.dart';
import 'package:tech_fun/models/order_detail.dart';
import 'package:tech_fun/models/product_detail.dart';
import 'package:tech_fun/utils/database_service.dart';
import 'package:tech_fun/utils/formatcurrency.dart';
import 'package:tech_fun/utils/secure_storage_service.dart';
import 'package:tech_fun/views/main/layout_page.dart';
import 'package:tech_fun/views/mid/order_detail_page.dart' hide StatusOrder;

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<OrderDetail> orders = [];

  Color _getStatusColor(StatusOrder status) {
    switch (status) {
      case StatusOrder.Processing:
        return Colors.orangeAccent;
      case StatusOrder.Shipped:
        return Colors.blueAccent;
      case StatusOrder.Delivered:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDataFuture = loadData();
  }

  late Future<void> _loadDataFuture;

  Future<void> loadData() async {
    if (SecureStorageService.currentUser ==
        SecureStorageService.offlineStatus) {
      orders = [];
      return;
    }

    orders = await FirebaseCloundService.getAllOrdersWithUser(
      SecureStorageService.currentUser,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // dark modern tech background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LayoutPage()),
            );
          },
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: FutureBuilder(
        future: _loadDataFuture,
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading....');
            default:
              if (asyncSnapshot.hasError) {
                return Text('Error: ${asyncSnapshot.error}');
              } else {
                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: Colors.white24,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No orders yet.',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailPage(order: order),
                          ),
                        );
                      },
                      child: Card(
                        color: const Color(0xFF1E293B),
                        shadowColor: _getStatusColor(order.status),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Order ID and Date
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order.id,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    order.dateCreated,
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Title
                              Text(
                                order.user,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Price and Status
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatCurrency(
                                      (order.total -
                                              (order.total *
                                                  order.discount /
                                                  100))
                                          .toInt(),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.cyanAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        order.status,
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      order.status.name,
                                      style: TextStyle(
                                        color: _getStatusColor(order.status),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}
