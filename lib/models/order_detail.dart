import 'package:tech_fun/models/product_detail.dart';

enum StatusOrder { None, Processing, Shipped, Delivered }

class OrderDetail {
  final String user;
  final Map<ProductDetail, int> items;
  final double discount;
  final int total;
  final String id;
  final String dateCreated;
  final StatusOrder status;
  final List<String> address;

  OrderDetail({
    required this.user,
    required this.items,
    required this.total,
    required this.discount,
    required this.id,
    required this.dateCreated,
    required this.status,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'items': items.entries.map((entry) {
        return {'product': entry.key.toMap(), 'quantity': entry.value};
      }).toList(),
      'discount': discount,
      'total': total,
      'id': id,
      'dateCreated': dateCreated,
      'status': status.name,
      'address': address,
    };
  }

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    final Map<ProductDetail, int> parsedItems = {};

    for (var item in (map['items'] as List<dynamic>)) {
      final productMap = Map<String, dynamic>.from(item['product']);
      final product = ProductDetail.fromMap(productMap);
      final quantity = item['quantity'] ?? 0;
      parsedItems[product] = quantity;
    }

    return OrderDetail(
      user: map['user'] ?? '',
      items: parsedItems,
      total: map['total'] ?? 0,
      discount: (map['discount'] ?? 0).toDouble(),
      id: map['id'] ?? '',
      dateCreated: map['dateCreated'] ?? '',
      status: StatusOrder.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'None'),
        orElse: () => StatusOrder.None,
      ),
      address: List<String>.from(map['address'] ?? []),
    );
  }
}
