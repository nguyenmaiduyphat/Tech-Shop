// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tech_fun/models/chat_detail.dart';
import 'package:tech_fun/models/comment_detail.dart';
import 'package:tech_fun/models/event_detail.dart';
import 'package:tech_fun/models/news_detail.dart';
import 'package:tech_fun/models/order_detail.dart';
import 'package:tech_fun/models/post_info.dart';
import 'package:tech_fun/models/product_detail.dart';
import 'package:tech_fun/models/review_detail.dart';
import 'package:tech_fun/models/shop_detail.dart';
import 'package:tech_fun/models/user_detail.dart';

enum NameTable {
  USERS,
  POSTS,
  PRODUCTS,
  ORDERS,
  STORE,
  EVENTS,
  NEWS,
  COMMENTS,
  REVIEWS,
  CHATS,
}

class FirebaseCloundService {
  /// USERS

  static Future<void> addUser(UserDetail user) async {
    await FirebaseFirestore.instance
        .collection(NameTable.USERS.name)
        .add(user.toMap());
  }

  static Stream<List<Map<String, dynamic>>> getUsers() {
    return FirebaseFirestore.instance
        .collection(NameTable.USERS.name)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => doc.data()).toList();
        });
  }

  static Future<UserDetail?> getUserByEmail(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(NameTable.USERS.name)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return UserDetail.fromMap(snapshot.docs.first.data());
    }
    return null;
  }

  static Future<void> updateUser(UserDetail user) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection(NameTable.USERS.name)
          .where('email', isEqualTo: user.email)
          .get();

      if (query.docs.isEmpty) {
        print('No user found with email: ${user.email}');
        return;
      }

      for (var doc in query.docs) {
        await FirebaseFirestore.instance
            .collection(NameTable.USERS.name)
            .doc(doc.id)
            .update(user.toMap()); // update with your toMap()
      }

      print('User(s) updated successfully.');
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  static Future<void> deleteUser(String email) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection(NameTable.USERS.name)
          .where('email', isEqualTo: email)
          .get();

      if (query.docs.isEmpty) {
        print('No user found with email: $email');
        return;
      }

      for (var doc in query.docs) {
        await FirebaseFirestore.instance
            .collection(NameTable.USERS.name)
            .doc(doc.id)
            .delete();
      }

      print('User(s) deleted successfully.');
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  /// PRODUCT
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addProduct(ProductDetail product) async {
    await _firestore
        .collection(NameTable.PRODUCTS.name)
        .doc(product.id)
        .set(product.toMap());
  }

  static Future<List<ProductDetail>> getAllProducts() async {
    final snapshot = await _firestore.collection(NameTable.PRODUCTS.name).get();
    return snapshot.docs
        .map((doc) => ProductDetail.fromMap(doc.data()))
        .toList();
  }

  static Future<ProductDetail?> getProductById(String id) async {
    final doc = await _firestore
        .collection(NameTable.PRODUCTS.name)
        .doc(id)
        .get();
    if (doc.exists) {
      return ProductDetail.fromMap(doc.data()!);
    }
    return null;
  }

  static Future<void> updateProduct(
    String id,
    Map<String, dynamic> updatedData,
  ) async {
    await _firestore
        .collection(NameTable.PRODUCTS.name)
        .doc(id)
        .update(updatedData);
  }

  static Future<void> deleteProduct(String id) async {
    await _firestore.collection(NameTable.PRODUCTS.name).doc(id).delete();
  }

  /// COMMENTS
  static Future<void> addComment(CommentDetail comment) async {
    await _firestore.collection(NameTable.COMMENTS.name).add(comment.toMap());
  }

  static Future<List<CommentDetail>> getAllComments(String id) async {
    final snapshot = await _firestore
        .collection(NameTable.COMMENTS.name)
        .where('id', isEqualTo: id)
        .get();
    return snapshot.docs
        .map((doc) => CommentDetail.fromMap(doc.data()))
        .toList();
  }

  /// EVENTS
  static Future<void> addEvent(EventDetail event) async {
    await _firestore.collection(NameTable.EVENTS.name).add(event.toMap());
  }

  static Future<List<EventDetail>> getAllEvents() async {
    final snapshot = await _firestore.collection(NameTable.EVENTS.name).get();
    return snapshot.docs.map((doc) => EventDetail.fromMap(doc.data())).toList();
  }

  /// NEWS
  static Future<void> addNews(NewsDetail news) async {
    await _firestore.collection(NameTable.NEWS.name).add(news.toMap());
  }

  static Future<List<NewsDetail>> getAllNews() async {
    final snapshot = await _firestore.collection(NameTable.NEWS.name).get();
    return snapshot.docs.map((doc) => NewsDetail.fromMap(doc.data())).toList();
  }

  /// ORDERS
  static Future<void> addOrder(OrderDetail order) async {
    await _firestore.collection(NameTable.ORDERS.name).add(order.toMap());
  }

  static Future<List<OrderDetail>> getAllOrders() async {
    final snapshot = await _firestore.collection(NameTable.ORDERS.name).get();
    return snapshot.docs.map((doc) => OrderDetail.fromMap(doc.data())).toList();
  }

  static Future<List<OrderDetail>> getAllOrdersWithUser(String email) async {
    final snapshot = await _firestore
        .collection(NameTable.ORDERS.name)
        .where('user', isEqualTo: email)
        .get();
    return snapshot.docs.map((doc) => OrderDetail.fromMap(doc.data())).toList();
  }

  /// POSTS
  static Future<void> addPost(PostInfo post) async {
    await _firestore.collection(NameTable.POSTS.name).add(post.toMap());
  }

  static Future<List<PostInfo>> getAllPosts() async {
    final snapshot = await _firestore.collection(NameTable.POSTS.name).get();
    return snapshot.docs.map((doc) => PostInfo.fromMap(doc.data())).toList();
  }

  static Future<List<PostInfo>> getAllPostsWithEmail(String email) async {
    final snapshot = await _firestore
        .collection(NameTable.POSTS.name)
        .where('nameUser', isEqualTo: email)
        .get();
    return snapshot.docs.map((doc) => PostInfo.fromMap(doc.data())).toList();
  }

  /// REVIEWS
  static Future<void> addReview(ReviewDetail review) async {
    await _firestore.collection(NameTable.REVIEWS.name).add(review.toMap());
  }

  static Future<List<ReviewDetail>> getAllReviewsWithIdProduct({
    required String id,
    required int amount,
  }) async {
    QuerySnapshot<Map<String, dynamic>>? snapshot;
    if (amount != 0) {
      snapshot = await _firestore
          .collection(NameTable.REVIEWS.name)
          .where('idProduct', isEqualTo: id)
          .limit(amount)
          .get();
    } else {
      snapshot = await _firestore
          .collection(NameTable.REVIEWS.name)
          .where('idProduct', isEqualTo: id)
          .get();
    }
    return snapshot.docs
        .map((doc) => ReviewDetail.fromMap(doc.data()))
        .toList();
  }

  /// SHOPS
  static Future<void> addShop(ShopDetail shop) async {
    await _firestore.collection(NameTable.STORE.name).add(shop.toMap());
  }

  // ✅ Get shop by `id` field
  static Future<ShopDetail?> getShopById(String email) async {
    final snapshot = await _firestore
        .collection(NameTable.STORE.name)
        .where('user', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return ShopDetail.fromMap(snapshot.docs.first.data());
    }
    return null;
  }

  static Future<ShopDetail?> getShopByNameShop(String name) async {
    final snapshot = await _firestore
        .collection(NameTable.STORE.name)
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return ShopDetail.fromMap(snapshot.docs.first.data());
    }
    return null;
  }

  // ✅ Update shop by `id` field
  static Future<void> updateShop(String shopId, ShopDetail shop) async {
    final snapshot = await _firestore
        .collection(NameTable.STORE.name)
        .where('id', isEqualTo: shopId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      await snapshot.docs.first.reference.update(shop.toMap());
    }
  }

  /// CHATS
  static Future<void> addChat(ChatDetail shop) async {
    await _firestore.collection(NameTable.CHATS.name).add(shop.toMap());
  }

  static Future<List<ChatDetail>> getAllChatsWithIdShop({
    required String id,
  }) async {
    QuerySnapshot<Map<String, dynamic>>? snapshot;
    snapshot = await _firestore
        .collection(NameTable.CHATS.name)
        .where('id', isEqualTo: id)
        .get();
    return snapshot.docs.map((doc) => ChatDetail.fromMap(doc.data())).toList();
  }
}

class FirebaseRealtimeService {
  static final dbRef = FirebaseDatabase.instance.ref();

  /// ➕ Thêm comment
  static Future<void> addComment(CommentDetail comment) async {
    await dbRef
        .child("${NameTable.COMMENTS.name}/${comment.id}")
        .set(comment.toMap());
  }

  /// 📖 Đọc toàn bộ comments (realtime stream)
  Stream<DatabaseEvent> readComments() {
    return dbRef.child(NameTable.COMMENTS.name).onValue;
  }

  /// 🔄 Update comment theo id
  Future<void> updateComment(String id, Map<String, dynamic> updates) async {
    try {
      final snapshot = await dbRef
          .child(NameTable.COMMENTS.name)
          .orderByChild('id')
          .equalTo(id)
          .once();

      if (snapshot.snapshot.value == null) {
        print('No comment found with id: $id');
        return;
      }

      final data = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      data.forEach((commentId, _) async {
        await dbRef
            .child('${NameTable.COMMENTS.name}/$commentId')
            .update(updates);
        print('Comment $commentId updated.');
      });
    } catch (e) {
      print('Error updating comment: $e');
    }
  }

  /// ❌ Xóa comment theo id
  Future<void> deleteComment(String id) async {
    try {
      final snapshot = await dbRef
          .child(NameTable.COMMENTS.name)
          .orderByChild('id')
          .equalTo(id)
          .once();

      if (snapshot.snapshot.value == null) {
        print('No comment found with id: $id');
        return;
      }

      final data = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      data.forEach((commentId, _) async {
        await dbRef.child('${NameTable.COMMENTS.name}/$commentId').remove();
        print('Comment $commentId deleted.');
      });
    } catch (e) {
      print('Error deleting comment: $e');
    }
  }
}
