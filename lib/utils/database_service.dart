// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tech_fun/models/product_detail.dart';
import 'package:tech_fun/models/user_detail.dart';

enum NameTable {
  USERS,
  POSTS,
  PRODUCTS,
  ORDERS,
  STORE,
  FINANCE,
  EVENTS,
  NEWS,
  REVIEWS,
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
}

class FirebaseRealtimeService {
  final dbRef = FirebaseDatabase.instance.ref();

  Future<void> addUser(UserDetail user) async {
    await dbRef
        .child("${NameTable.USERS.name}/${user.email}")
        .set(user.toMap());
  }

  Stream<DatabaseEvent> readUsers() {
    return dbRef.child("${NameTable.USERS.name}").onValue;
  }

  Future<void> updateUser(String email, Map<String, dynamic> updates) async {
    try {
      final snapshot = await dbRef
          .child(NameTable.USERS.name)
          .orderByChild('email')
          .equalTo(email)
          .once();

      if (snapshot.snapshot.value == null) {
        print('No user found with email: $email');
        return;
      }

      final data = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      data.forEach((userId, userData) async {
        await dbRef.child('${NameTable.USERS.name}/$userId').update(updates);
        print('User $userId updated.');
      });
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  Future<void> deleteUser(String email) async {
    try {
      final snapshot = await dbRef
          .child(NameTable.USERS.name)
          .orderByChild('email')
          .equalTo(email)
          .once();

      if (snapshot.snapshot.value == null) {
        print('No user found with email: $email');
        return;
      }

      final data = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      data.forEach((userId, userData) async {
        await dbRef.child('${NameTable.USERS.name}/$userId').remove();
        print('User $userId deleted.');
      });
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}
