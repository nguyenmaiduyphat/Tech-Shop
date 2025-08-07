class ShopDetail {
  final String name;
  late int orderBoughtTotal;
  late int productTotal;
  late int postTotal;
  late int revenueTotal;

  ShopDetail({
    required this.name,
    required this.orderBoughtTotal,
    required this.productTotal,
    required this.postTotal,
    required this.revenueTotal,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'orderBoughtTotal': orderBoughtTotal,
      'productTotal': productTotal,
      'postTotal': postTotal,
      'revenueTotal': revenueTotal,
    };
  }

  factory ShopDetail.fromMap(Map<String, dynamic> map) {
    return ShopDetail(
      name: map['name'] ?? '',
      orderBoughtTotal: map['orderBoughtTotal'] ?? 0,
      productTotal: map['productTotal'] ?? 0,
      postTotal: map['postTotal'] ?? 0,
      revenueTotal: map['revenueTotal'] ?? 0,
    );
  }
}
