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
import 'package:tech_fun/utils/database_service.dart';
import 'package:tech_fun/utils/formatcurrency.dart';
import 'package:tech_fun/utils/secure_storage_service.dart';

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
      price: (random.nextInt(100000000 - 100000 + 1) + 100000),
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
final List<String> techProductReviews = [
  "Sản phẩm dùng mượt mà, pin trâu, rất đáng tiền!",
  "Thiết kế đẹp, hiệu năng ổn định. Mình rất hài lòng.",
  "Tính năng mới thực sự tiện lợi, đặc biệt là chế độ tiết kiệm pin.",
  "Chạy ứng dụng nặng vẫn rất mượt, không bị giật lag.",
  "Camera chụp ảnh quá đỉnh, màu sắc trung thực!",
  "Hỗ trợ cập nhật phần mềm nhanh chóng, đánh giá cao điểm này.",
  "Giá hơi cao nhưng trải nghiệm xứng đáng.",
  "Loa ngoài nghe to, rõ, xem phim cực đã!",
  "Thời lượng pin ấn tượng, dùng cả ngày không lo sạc.",
  "Mong hãng cải thiện thêm về khả năng tản nhiệt.",
  "Kết nối Wi-Fi ổn định, không bị rớt mạng.",
  "Sạc nhanh cực tiện, 30 phút đầy 70% pin.",
  "Màn hình sắc nét, màu sắc sống động.",
  "Cảm biến vân tay nhạy, mở khóa nhanh chóng.",
  "Chất lượng hoàn thiện tốt, cầm rất chắc tay.",
  "Phù hợp cho cả công việc lẫn giải trí.",
  "Trải nghiệm chơi game rất đã, FPS ổn định.",
  "Thiết bị nhẹ, dễ mang theo, tiện di chuyển.",
  "Khả năng đa nhiệm tốt, chuyển đổi ứng dụng mượt mà.",
  "Hệ điều hành tối ưu, ít lỗi vặt.",
  "Bàn phím gõ êm, phản hồi tốt.",
  "Touchpad nhạy, thao tác dễ dàng.",
  "Phù hợp với nhu cầu học online và làm việc từ xa.",
  "Thiết bị không nóng khi sử dụng lâu.",
  "Giao diện dễ sử dụng, thân thiện với người dùng.",
  "Loa kép nghe nhạc rất thích, âm bass rõ.",
  "Chế độ bảo mật cao, an tâm sử dụng.",
  "Có đầy đủ cổng kết nối cần thiết.",
  "Khả năng nhận diện khuôn mặt nhanh và chính xác.",
  "Máy khởi động nhanh, không phải chờ lâu.",
  "Dễ dàng đồng bộ với các thiết bị khác.",
  "Ứng dụng mặc định hữu ích và không rác.",
  "Chất lượng video call rất ổn, hình ảnh rõ nét.",
  "Dung lượng bộ nhớ lớn, lưu trữ thoải mái.",
  "Vỏ ngoài chống bám vân tay khá tốt.",
  "Thiết kế mỏng nhẹ, nhìn rất sang.",
  "Đáng đồng tiền bát gạo.",
  "Thích nhất là không bị quảng cáo làm phiền.",
  "Bắt sóng tốt kể cả khi ở nơi có tín hiệu yếu.",
  "Hiển thị ngoài trời rõ ràng, không bị chói.",
  "Mình đã giới thiệu cho bạn bè, ai cũng thích.",
  "Phụ kiện đi kèm đầy đủ và chất lượng tốt.",
  "Hỗ trợ kỹ thuật nhanh và nhiệt tình.",
  "Máy hoạt động êm, không có tiếng ồn.",
  "Rất hợp với người mới bắt đầu làm quen công nghệ.",
  "Chạy ổn định ngay cả khi mở nhiều tab trình duyệt.",
  "Thao tác vuốt chạm mượt như iOS.",
  "Được bảo hành chính hãng, yên tâm sử dụng.",
  "Mình dùng gần 1 năm rồi vẫn chạy tốt.",
  "Không nghĩ sản phẩm Việt Nam lại chất lượng vậy!",
];

final List<String> sampleUsers = [
  "Nguyen Van A",
  "Tran Thi B",
  "Le Van C",
  "Pham Thi D",
  "Hoang Van E",
];

final List<String> sampleShopNames = [
  "GearVN",
  "Adidas",
  "Yashigi",
  "V Lieng King",
  "TopTier",
  "BingGoAnt",
];

List<CommentDetail> generateSampleComments_Post(int count) {
  return List.generate(count, (index) {
    return CommentDetail(
      id: 'P$index',
      content: sampleContents[random.nextInt(sampleContents.length)],
      avatar: 'assets/user/user1.jpg',
      user: sampleUsers[random.nextInt(sampleUsers.length)],
    );
  });
}

List<CommentDetail> generateSampleComments_News(int count) {
  return List.generate(count, (index) {
    return CommentDetail(
      id: 'N$index',
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
    id: 'P$i',
    emojiTotal: random.nextInt(1000),
    commentTotal: random.nextInt(300),
    shareTotal: random.nextInt(100),
    currentIcon: '⚫',
    avatarUser: 'assets/user/user1.jpg',
    nameUser: 'user$i@gmail.com',
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
  );
});

List<ReviewDetail> generateReviews() => List.generate(50, (i) {
  return ReviewDetail(
    idProduct: 'P$i',
    content: techProductReviews[random.nextInt(50)],
    rate: (random.nextInt(5) + random.nextDouble()).clamp(1.0, 5.0),
    image: 'assets/product/product1.jpg',
    avatar: 'assets/user/user1.jpg',
    user: 'user$i@gmail.com',
  );
});

List<ShopDetail> generateShops() => List.generate(sampleShops.length, (i) {
  return ShopDetail(
    name: sampleShops[i],
    user: 'user$i@gmail.com',
    orderBoughtTotal: random.nextInt(1000),
    productTotal: random.nextInt(200),
    postTotal: random.nextInt(200),
    revenueTotal: random.nextInt(1000000),
  );
});

List<OrderDetail> generateOrders(List<ProductDetail> productList) {
  return List.generate(50, (i) {
    // Generate a random subset of products
    final selectedProducts = productList.toList()..shuffle();
    final itemCount = random.nextInt(productList.length) + 1;

    final Map<ProductDetail, int> itemMap = {};

    for (var j = 0; j < itemCount; j++) {
      final product = selectedProducts[j];
      final quantity = random.nextInt(5) + 1; // 1 to 5
      itemMap[product] = quantity;
    }

    // Calculate total
    final total = itemMap.entries.fold<double>(
      0,
      (sum, entry) => sum + entry.key.price * entry.value,
    );

    // Generate random discount (0.0 to 66.0)
    final discount = double.parse(
      (random.nextDouble() * 66).toStringAsFixed(1),
    );

    // Random status
    final statusIndex = random.nextInt(3); // 0, 1, or 2
    final statusOrder =
        StatusOrder.values[statusIndex + 1]; // Skip StatusOrder.None

    return OrderDetail(
      user: 'user$i@gmail.com',
      items: itemMap,
      total: total.toInt(),
      discount: discount,
      id: SecureStorageService.currentUser == SecureStorageService.offlineStatus
          ? generateOrderCode()
          : SecureStorageService.currentUser,
      dateCreated: DateTime.now()
          .subtract(Duration(days: random.nextInt(365)))
          .toIso8601String(),
      status: statusOrder,
    );
  });
}

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
