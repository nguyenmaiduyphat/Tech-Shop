import 'dart:math';

import 'package:tech_fun/models/post_info.dart';
import 'package:tech_fun/models/review_detail.dart';
import 'package:tech_fun/models/shop_detail.dart';
import 'package:tech_fun/models/user_detail.dart';
import 'package:tech_fun/models/comment_detail.dart';
import 'package:tech_fun/models/event_detail.dart';
import 'package:tech_fun/models/news_detail.dart';
import 'package:tech_fun/models/order_detail.dart';
import 'package:tech_fun/models/product_detail.dart';

final List<String> sampleImages = [
  "assets/product/product1.jpg",
  "assets/product/product2.jpg",
  "assets/product/product3.jpg",
  "assets/product/product4.jpg",
  "assets/product/product5.jpg",
  "assets/product/product7.jpg",
];

final List<String> sampleShops = ["Shop A", "Shop B", "Shop C"];
final List<String> sampleBrands = ["Brand X", "Brand Y", "Brand Z"];
final List<String> sampleLocations = ["Hà Nội", "TP.HCM", "Đà Nẵng"];
final Random random = Random();

List<ProductDetail> generateSampleProducts(int count) {
  return List.generate(count, (index) {
    return ProductDetail(
      id: 'P$index',
      name: 'Product $index',
      images: List.generate(
        3,
        (_) => sampleImages[random.nextInt(sampleImages.length)],
      ),
      price: (random.nextInt(100000000 - 100000 + 1) + 100000).toDouble(),
      discount: double.parse((random.nextDouble() * 30).toStringAsFixed(2)),
      rate: double.parse((random.nextDouble() * 5).toStringAsFixed(1)),
      deliveryDays: random.nextInt(7) + 1,
      solds: random.nextInt(1000),
      location: sampleLocations[random.nextInt(sampleLocations.length)],
      description: 'This is the description for product $index.',
      detail: {
        "color": ["Red", "Blue", "Green"][random.nextInt(3)],
        "size": ["S", "M", "L", "XL"][random.nextInt(4)],
        "weight": "${random.nextInt(5) + 1}kg",
      },
      shop: sampleShops[random.nextInt(sampleShops.length)],
      brand: sampleBrands[random.nextInt(sampleBrands.length)],
      date: DateTime.now()
          .subtract(Duration(days: random.nextInt(365)))
          .year
          .toString(),
    );
  });
}

final List<String> sampleContents = [
  "Bài viết rất hay!",
  "Cảm ơn bạn đã chia sẻ.",
  "Mình đồng ý với quan điểm này.",
  "Thông tin hữu ích quá!",
  "Like mạnh!",
  "Có ai nghĩ giống mình không?",
  "Tuyệt vời!",
  "Thật đáng suy ngẫm.",
  "Ủng hộ bài viết này.",
  "Mong có thêm nhiều bài như vậy.",
];

final List<String> sampleUsers = [
  "Nguyen Van A",
  "Tran Thi B",
  "Le Van C",
  "Pham Thi D",
  "Hoang Van E",
];

List<CommentDetail> generateSampleComments(int count) {
  return List.generate(count, (index) {
    return CommentDetail(
      id: 'comment_$index',
      content: sampleContents[random.nextInt(sampleContents.length)],
      avatar: 'assets/user/user1.jpg',
      user: sampleUsers[random.nextInt(sampleUsers.length)],
    );
  });
}

List<UserDetail> generateUsers() => List.generate(50, (i) {
  return UserDetail(
    username: 'user$i',
    password: 'pass$i',
    email: 'user$i@gmail.com',
    phone: '090${i.toString().padLeft(7, '0')}',
    address: 'Address $i',
    gender: i % 2 == 0 ? 'Male' : 'Female',
    birth: '199${i % 10}-01-01',
    CIC: 'CIC${100000 + i}',
    bankNumber: '123456789$i',
  );
});

List<PostInfo> generatePosts() => List.generate(50, (i) {
  return PostInfo(
    emojiTotal: random.nextInt(1000),
    commentTotal: random.nextInt(300),
    shareTotal: random.nextInt(100),
    currentIcon: '⚫',
    avatarUser: 'assets/user/user1.jpg',
    nameUser: 'User $i',
    datePost: '202${i % 10}-01-01',
    title: 'Post Title $i',
    content: 'This is the content of post $i.',
    imageContent: [
      'assets/product/product1.jpg',
      'assets/product/product2.jpg',
      'assets/product/product3.jpg',
      'assets/product/product4.jpg',
      'assets/product/product5.jpg',
      'assets/product/product6.jpg',
      'assets/product/product7.jpg',
    ],
    comments: List.generate(random.nextInt(5), (j) => 'Comment $j'),
  );
});

List<ReviewDetail> generateReviews() => List.generate(50, (i) {
  return ReviewDetail(
    idProduct: 'P$i',
    content: 'This is a review for product $i.',
    rate: (random.nextInt(5) + random.nextDouble()).clamp(1.0, 5.0),
    image: 'assets/product/product1.jpg',
    avatar: 'assets/user/user1.jpg',
    user: 'User $i',
  );
});

List<CommentDetail> generateComments() => List.generate(50, (i) {
  return CommentDetail(
    id: 'C$i',
    content: 'This is comment number $i.',
    avatar: 'assets/user/user1.jpg',
    user: 'User $i',
  );
});

List<ShopDetail> generateShops() => List.generate(50, (i) {
  return ShopDetail(
    name: 'Shop $i',
    orderBoughtTotal: random.nextInt(1000),
    productTotal: random.nextInt(200),
    postTotal: random.nextInt(50),
    revenueTotal: random.nextInt(1000000),
  );
});

List<OrderDetail> generateOrders() => List.generate(50, (i) {
  final items = {
    'P${random.nextInt(100)}': random.nextInt(5) + 1,
    'P${random.nextInt(100)}': random.nextInt(3) + 1,
  };
  final total = items.entries.fold(
    0,
    (sum, entry) => sum + entry.value * 100000,
  );
  final discount = (random.nextDouble() * 66).toStringAsFixed(
    1,
  ); // 0.0 to 66.0%
  return OrderDetail(
    user: 'User $i',
    items: items,
    total: total,
    discount: double.parse(discount),
  );
});
List<NewsDetail> generateNews() => List.generate(50, (i) {
  return NewsDetail(
    image: 'assets/product/product1.jpg',
    title: 'News Title $i',
    content: 'Content of news $i goes here.',
    owner: 'Editor $i',
    date: '202${i % 10}-01-01',
    views: random.nextInt(10000),
    likes: random.nextInt(500),
    dislikes: random.nextInt(50),
    id: 'N$i',
  );
});

List<EventDetail> generateEvents() => List.generate(50, (i) {
  return EventDetail(
    image: 'assets/product/product1.jpg',
    title: 'Event Title $i',
    content: 'Details about event $i.',
    owner: 'Organizer $i',
    location: 'Location $i',
    date: '202${i % 10}-12-0${(i % 9) + 1}',
    attendees: random.nextInt(1000),
  );
});
