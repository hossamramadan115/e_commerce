import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  // 🟢 إضافة بيانات المستخدم
  Future<void> addUserDetails(
      Map<String, dynamic> userInfoMap, String id) async {
    try {
      await usersCollection.doc(id).set(userInfoMap);
    } catch (e) {
      throw "Error saving user data: $e";
    }
  }


Future<DocumentSnapshot> getUserDetails(String id) async {
  try {
    return await usersCollection.doc(id).get();
  } catch (e) {
    throw "Error fetching user data: $e";
  }
}


Future<DocumentSnapshot?> getUserByEmail(String email) async {
  try {
    final snapshot = await usersCollection.where("email", isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first;
    }
    return null;
  } catch (e) {
    throw "Error fetching user by email: $e";
  }
}


  Future<void> addProduct(
    Map<String, dynamic> productInfoMap, String categoryName) async {
  try {
    await FirebaseFirestore.instance
        .collection(categoryName)
        .add(productInfoMap);

    await FirebaseFirestore.instance
        .collection("products")
        .add(productInfoMap);
  } catch (e) {
    throw "Error saving product: $e";
  }
}


  Stream<QuerySnapshot> getProducts(String category) {
    try {
      return FirebaseFirestore.instance
          .collection(category)
          .orderBy("createdAt", descending: true)
          .snapshots();
    } catch (e) {
      throw "Error fetching products: $e";
    }
  }

  Stream<QuerySnapshot> getAllProducts() {
  try {
    return FirebaseFirestore.instance
        .collection("products")
        .orderBy("createdAt", descending: true)
        .snapshots();
  } catch (e) {
    throw "Error fetching all products: $e";
  }
}


  Future<void> addOrderDetails(Map<String, dynamic> orderInfoMap) async {
    try {
      await FirebaseFirestore.instance.collection("Orders").add(orderInfoMap);
    } catch (e) {
      throw "Error saving order: $e";
    }
  }

  // 🟢 تجيب الأوردرات كـ Stream
Stream<QuerySnapshot> getOrders(String? email) {
  try {
    if (email == null) {
      throw "User is not logged in";
    }

    return FirebaseFirestore.instance
        .collection("Orders")
        .where("Email", isEqualTo: email) // 🟢 فلترة بالأيميل اللي جاي من SharedPreferences
        .snapshots();
  } catch (e) {
    throw "Error fetching orders: $e";
  }
}

  // 🟢 تجيب كل الأوردرات (للأدمن)
  Stream<QuerySnapshot> getAllOrders() {
    try {
      return FirebaseFirestore.instance
          .collection("Orders")
          .orderBy("createdAt", descending: true)
          .snapshots();
    } catch (e) {
      throw "Error fetching all orders: $e";
    }
  }

  // 🟢 تحديث حالة الأوردر
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection("Orders")
          .doc(orderId)
          .update({"Status": newStatus});
    } catch (e) {
      throw "Error updating order status: $e";
    }
  }

  Future<void> deleteOrder(String orderId) async {
  try {
    await FirebaseFirestore.instance
        .collection("Orders")
        .doc(orderId)
        .delete();
  } catch (e) {
    throw "Error deleting order: $e";
  }
}


    Future<void> deleteUser(String id) async {
    try {
      await usersCollection.doc(id).delete();
    } catch (e) {
      throw "Error deleting user: $e";
    }
  }
}