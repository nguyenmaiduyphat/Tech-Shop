import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tech_fun/firebase_options.dart';
import 'package:tech_fun/models/comment_detail.dart';
import 'package:tech_fun/models/event_detail.dart';
import 'package:tech_fun/models/news_detail.dart';
import 'package:tech_fun/models/order_detail.dart';
import 'package:tech_fun/models/post_info.dart';
import 'package:tech_fun/models/product_detail.dart';
import 'package:tech_fun/models/review_detail.dart';
import 'package:tech_fun/models/shop_detail.dart';
import 'package:tech_fun/models/user_detail.dart';
import 'package:tech_fun/utils/database_service.dart';
import 'package:tech_fun/utils/generatesamples.dart';
import 'package:tech_fun/utils/secure_storage_service.dart';
import 'package:tech_fun/views/main/layout_page.dart';
import 'package:tech_fun/views/mid/map_locate_delivery.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SecureStorageService.init();
  //await addData();

  // final productList = await FirebaseCloundService.getAllProducts();

  // final List<OrderDetail> myOrders = generateOrders(productList);
  // for (var x in myOrders) {
  //   await FirebaseCloundService.addOrder(x);
  // }
  runApp(const MyApp());
}

Future<void> addData() async {
  final List<ProductDetail> myProducts = generateSampleProducts(50);
  for (var product in myProducts) {
    await FirebaseCloundService.addProduct(product);
  }

  final List<CommentDetail> myComments = generateSampleComments_Post(50);
  for (var comment in myComments) {
    await FirebaseCloundService.addComment(comment);
  }

  final List<CommentDetail> mycommentsNews = generateSampleComments_News(50);
  for (var comment in mycommentsNews) {
    await FirebaseCloundService.addComment(comment);
  }

  final List<EventDetail> myEvents = generateEvents();
  for (var x in myEvents) {
    await FirebaseCloundService.addEvent(x);
  }

  final List<NewsDetail> myNews = generateNews();
  for (var x in myNews) {
    await FirebaseCloundService.addNews(x);
  }

  final List<OrderDetail> myOrders = generateOrders([]);
  for (var x in myOrders) {
    await FirebaseCloundService.addOrder(x);
  }

  final List<PostInfo> myPosts = generatePosts();
  for (var x in myPosts) {
    await FirebaseCloundService.addPost(x);
  }

  final List<ReviewDetail> myReviews = generateReviews();
  for (var x in myReviews) {
    await FirebaseCloundService.addReview(x);
  }

  final List<ShopDetail> myShops = generateShops();
  for (var x in myShops) {
    await FirebaseCloundService.addShop(x);
  }

  final List<UserDetail> myUsers = generateUsers();
  for (var x in myUsers) {
    await FirebaseCloundService.addUser(x);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Fun',
      theme: ThemeData(
        textTheme: GoogleFonts.tekturTextTheme(), // 👈 Global Poppins font
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true, // Optional for modern styling
      ),
      home: MapLocateDelivery(
        startPoint: 'Times Square, New York, NY',
        endPoint: 'Central Park, New York, NY',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
