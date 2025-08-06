class ProductDetail {
  final String id;
  late String name;
  late List<String> images;
  late double price;
  late double discount;
  late double rate;
  late int deliveryDays;
  late int solds;
  late String location;
  late String description;
  late Map<String, dynamic> detail;
  late String shop;

  ProductDetail({
    required this.id,
    required this.name,
    required this.images,
    required this.price,
    required this.discount,
    required this.rate,
    required this.deliveryDays,
    required this.solds,
    required this.location,
    required this.description,
    required this.detail,
    required this.shop,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'images': images,
      'price': price,
      'discount': discount,
      'rate': rate,
      'deliveryDays': deliveryDays,
      'solds': solds,
      'location': location,
      'description': description,
      'detail': detail,
      'shop': shop,
    };
  }

  factory ProductDetail.fromMap(Map<String, dynamic> map) {
    return ProductDetail(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      price: (map['price'] ?? 0),
      discount: (map['discount'] ?? 0),
      rate: (map['rate'] ?? 0),
      deliveryDays: map['deliveryDays'] ?? 0,
      solds: map['solds'] ?? 0,
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      detail: Map<String, dynamic>.from(map['detail'] ?? {}),
      shop: map['shop'] ?? '',
    );
  }
}
