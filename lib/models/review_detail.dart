class ReviewDetail {
  final String idProduct;
  final String content;
  final double rate;
  final String image;
  final String avatar;
  final String user;

  ReviewDetail({
    required this.idProduct,
    required this.content,
    required this.rate,
    required this.image,
    required this.avatar,
    required this.user,
  });
  Map<String, dynamic> toMap() {
    return {
      'idProduct': idProduct,
      'content': content,
      'rate': rate,
      'image': image,
      'avatar': avatar,
      'user': user,
    };
  }

  factory ReviewDetail.fromMap(Map<String, dynamic> map) {
    return ReviewDetail(
      idProduct: map['idProduct'] ?? '',
      content: map['content'] ?? '',
      rate: (map['rate'] ?? 0).toDouble(),
      image: map['image'] ?? '',
      avatar: map['avatar'] ?? '',
      user: map['user'] ?? '',
    );
  }
}
