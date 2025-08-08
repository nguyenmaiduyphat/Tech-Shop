class ShopDetail {
  final String name;
  final String user;
  late int orderBoughtTotal;
  late int productTotal;
  late int postTotal;
  late int revenueTotal;

  ShopDetail({
    required this.name,
    required this.user,
    required this.orderBoughtTotal,
    required this.productTotal,
    required this.postTotal,
    required this.revenueTotal,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'user': user,
      'orderBoughtTotal': orderBoughtTotal,
      'productTotal': productTotal,
      'postTotal': postTotal,
      'revenueTotal': revenueTotal,
    };
  }

  factory ShopDetail.fromMap(Map<String, dynamic> map) {
    return ShopDetail(
      name: map['name'] ?? '',
      user: map['user'] ?? '',
      orderBoughtTotal: map['orderBoughtTotal'] ?? 0,
      productTotal: map['productTotal'] ?? 0,
      postTotal: map['postTotal'] ?? 0,
      revenueTotal: map['revenueTotal'] ?? 0,
    );
  }
}
