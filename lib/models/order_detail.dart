import 'package:tech_fun/models/product_detail.dart';

enum StatusOrder { None, Processing, Shipped, Delivered }

class OrderDetail {
  final String user;
  final List<ProductDetail> items;
  final double discount;
  final int total;
  final String id;
  final String dateCreated;
  final StatusOrder status;

  OrderDetail({
    required this.user,
    required this.items,
    required this.total,
    required this.discount,
    required this.id,
    required this.dateCreated,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'items': items.map((item) => item.toMap()).toList(),
      'discount': discount,
      'total': total,
      'id': id,
      'dateCreated': dateCreated,
      'status': status.name, // convert enum to string
    };
  }

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      user: map['user'] ?? '',
      items: (map['items'] as List<dynamic>)
          .map((item) => ProductDetail.fromMap(Map<String, dynamic>.from(item)))
          .toList(),
      total: map['total'] ?? 0,
      discount: (map['discount'] ?? 0).toDouble(),
      id: map['id'] ?? '',
      dateCreated: map['dateCreated'] ?? '',
      status: StatusOrder.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'None'),
        orElse: () => StatusOrder.None,
      ),
    );
  }
}
