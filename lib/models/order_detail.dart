class OrderDetail {
  final String user;
  final Map<String, int> items;
  final double discount;
  final int total;

  OrderDetail({
    required this.user,
    required this.items,
    required this.total,
    required this.discount,
  });
  Map<String, dynamic> toMap() {
    return {'user': user, 'items': items, 'discount': discount, 'total': total};
  }

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      user: map['user'] ?? '',
      items: Map<String, int>.from(map['items'] ?? {}),
      total: map['total'] ?? 0,
      discount: (map['discount'] ?? 0).toDouble(),
    );
  }
}
