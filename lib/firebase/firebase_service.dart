import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fresh_find_user/models/address.dart';
import 'package:fresh_find_user/models/order.dart';

import '../models/cart.dart';
import '../models/category.dart';
import '../models/item.dart';
import '../models/user_data.dart';
import '../models/vendor.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  String? _verificationId;

  Future<void> verifyPhoneNumber(
      String phoneNumber, Function onCodeSent, Function onError) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      onError("Failed to verify phone number: $e");
    }
  }

  Future<void> signInWithPhoneNumber(
      String smsCode, Function onSuccess, Function onSignInFailed) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: smsCode);
      var user = await _firebaseAuth.signInWithCredential(credential);
      onSuccess(user);
    } catch (e) {
      onSignInFailed("Failed to sign in: $e");
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<bool> createUser(UserData user) async {
    try {
      await _database.ref('users').child(user.id).set(user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkIfUserExists(String userId) async {
    try {
      final snapshot = await _database.ref().child('users/$userId').get();
      if (snapshot.exists) {
        print('User exists.');
        return true;
      } else {
        print('User does not exist.');
        return false;
      }
    } catch (e) {
      throw Exception('Failed to check if user exists');
    }
  }

  Future<UserData?> getUserData() async {
    try {
      var userId = _firebaseAuth.currentUser!.uid;

      DataSnapshot snapshot = await _database.ref("users").child(userId).get();
      if (snapshot.value != null) {
        return UserData.fromJson(snapshot.value);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> updateUserData(UserData userData) async {
    try {
      await _database.ref("users").child(userData.id).update({
        'name': userData.name,
        'email': userData.email,
        // You can add more fields to update here if needed
      });
    } catch (e) {
      print('Error updating user data: $e');
      throw e;
    }
  }

  Future<List<Category>> getCategoriesOnce() async {
    final _database = FirebaseDatabase.instance; // Assuming _database is your FirebaseDatabase instance
    List<Category> categories = [];

    // Fetch the snapshot once
    DataSnapshot snapshot = await _database.ref().child('categories').get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> categoriesMap = snapshot.value as Map<dynamic, dynamic>;
      categoriesMap.forEach((key, value) {
        final category = Category.fromJson(Map<String, dynamic>.from(value));
        categories.add(category);
      });
    }

    return categories;
  }

  Future<List<Vendor>> getVendorsByCategoryId(String categoryId) async {
    try {
      final response = await _database
          .ref()
          .child('vendors')
          .orderByChild('categoryId')
          .equalTo(categoryId)
          .once();
      List<Vendor> vendors = [];
      response.snapshot.children.forEach((child) {
        var vendorData = child.value as Map<dynamic, dynamic>;
        vendors.add(Vendor.fromJson(vendorData));
      });
      return vendors;
    } catch (e) {
      print("Error fetching vendors: $e");
      return [];
    }
  }

  Future<List<Item>> fetchItems(String vendorId) async {
    List<Item> items = [];
    try {

      final snapshot = await _database.ref().child('items/$vendorId').get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> productsMap =
        snapshot.value as Map<dynamic, dynamic>;
        productsMap.forEach((key, value) {
          final item = Item.fromJson(value);
          items.add(item);
        });
      }
    } catch (e) {
      return items;
    }
    return items;
  }

  Future<List<Item>> searchItemByName(String query) async {
    final allItems = await fetchSearchItems();
    return allItems
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<Item>> fetchSearchItems() async {
    List<Item> items = [];
    try {
      final snapshot = await _database.ref().child('all-items').get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> productsMap =
        snapshot.value as Map<dynamic, dynamic>;
        productsMap.forEach((key, value) {
          final item = Item.fromJson(value);
          items.add(item);
        });
      }
    } catch (e) {
      return items;
    }
    return items;
  }

  Future<List<Category>> searchCategoryByName(String query) async {
    final allItems = await fetchSearchCategories();
    return allItems
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<Category>> fetchSearchCategories() async {
    List<Category> categories = [];
    try {
      final snapshot = await _database.ref().child('categories').get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> categoryMap =
        snapshot.value as Map<dynamic, dynamic>;
        categoryMap.forEach((key, value) {
          final category = Category.fromJson(value);
          categories.add(category);
        });
      }
    } catch (e) {
      return categories;
    }
    return categories;
  }

  Future<void> addToCart(Item item, int quantity) async {
    var userId = _firebaseAuth.currentUser!.uid;

    DatabaseReference cartRef =
    _database.ref().child('userCarts/$userId/items/${item.id}');

    final snapshot = await cartRef.get();
    if (snapshot.exists) {
      // Item exists, update quantity
      int currentQuantity =
      (snapshot.value as Map<dynamic, dynamic>)['quantity'];
      cartRef.update({
        'quantity': quantity,
        'totalPrice': (item.price * quantity).toDouble(),
      });
    } else {
      // New item, add to cart
      cartRef.set({
        'id': item.id,
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'unit': item.unit,
        'imageUrl': item.imageUrl,
        'quantity': quantity,
        'vendorId': item.vendorId,
        'totalPrice': (item.price * quantity).toDouble(),
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  Stream<List<Cart>> getCartItems() {
    var userId = FirebaseAuth.instance.currentUser!.uid;


    Stream<DatabaseEvent> stream =
        _database.ref().child('userCarts').child(userId).child('items').onValue;

    return stream.map((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        // Convert the data snapshot to a map and then to a List<Cart>
        Map<dynamic, dynamic> cartMap = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);
        List<Cart> cartItems = cartMap.values
            .map((item) => Cart.fromJson(Map<dynamic, dynamic>.from(item)))
            .toList();
        return cartItems;
      } else {
        return <Cart>[]; // Return an empty list if there's no data
      }
    });
  }

  Future<void> updateCartItem(Cart cartItem) async {
    try {
      var userId = _firebaseAuth.currentUser!.uid;

      await _database.ref().child('userCarts').child(userId).child('items').child(cartItem.id).update(cartItem.toJson());
      print('Cart item updated successfully');
    } catch (e) {
      print('Error updating cart item: $e');
    }
  }

  Future<void> removeCartItem( String cartItemId) async {
    try {

      var userId = _firebaseAuth.currentUser!.uid;

      await _database.ref()
          .child('userCarts')
          .child(userId)
          .child('items')
          .child(cartItemId)
          .remove();
      print('Cart item removed successfully');
    } catch (e) {
      print('Error removing cart item: $e');
    }
  }

  Future<List<Cart>> getCartItemOnce() async {
    List<Cart> cartItems = [];
    try {

      var userId = _firebaseAuth.currentUser!.uid;

      DatabaseReference ref = _database.ref('userCarts/$userId/items');
      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> items = snapshot.value as Map<dynamic, dynamic>;
        items.forEach((key, value) {
          Cart cartItem = Cart(
            id: value['id'],
            name: value['name'],
            description: value['description'],
            imageUrl: value['imageUrl'],
            price: double.parse(value['price'].toString()),
            quantity: int.parse(value['quantity'].toString()),
            totalPrice: double.parse(value['totalPrice'].toString()),
            unit: value['unit'], createdAt: value['createdAt'],
            vendorId: value['vendorId']
          );
          cartItems.add(cartItem);
        });
      }
    } catch (e) {
      print("An error occurred while fetching cart items: ${e.toString()}");
      // Optionally, handle the error in a way that's appropriate for your app
    }
    return cartItems;
  }

  Future<void> addAddress(Address address) async {
    var userId = _firebaseAuth.currentUser!.uid;
    var id = _database.ref('userAddresses/$userId').push().key;
    address.id = id.toString();
    //DatabaseReference addressRef = _database.ref('userAddresses/$userId').push();
    // Set the address data
    await _database.ref('userAddresses/$userId').child(address.id).set(address.toJson());
  }

  Stream<List<Address>> getAddressStream() {

    var userId = _firebaseAuth.currentUser!.uid;

    Stream<DatabaseEvent> stream =
        _database.ref().child('userAddresses').child(userId).onValue;

    return stream.map((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        // Convert the data snapshot to a map and then to a List<Cart>
        Map<dynamic, dynamic> addressMap = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);
        List<Address> addressItems = addressMap.values
            .map((item) => Address.fromJson(Map<dynamic, dynamic>.from(item)))
            .toList();
        return addressItems;
      } else {
        return <Address>[]; // Return an empty list if there's no data
      }
    });
  }

  Future<void> placeOrder(Order order) async {

    String? id = _database.ref().child('orders').push().key;
    order.orderId = id;
    if(id!=null){
      await _database.ref().child('orders').child(id).set(order.toJson());
      await _database.ref().child('vendorOrders').set(order.toVendorSpecificOrdersJson());
      await _database.ref().child('userCarts').child(order.userId!).remove();
    }

  }


  Stream<List<Order>> get orderStream {

    var userId = _firebaseAuth.currentUser!.uid;

    return _database
        .ref()
        .child('orders')
        .orderByChild('userId')
        .equalTo(userId)
        .onValue
        .map((event) {
      dynamic ordersMap = event.snapshot.value ?? {};
      List<Order> orders = [];
      ordersMap.forEach((key, value) {
        orders.add(Order.fromJson(Map<String, dynamic>.from(value)));
      });
      return orders;
    });
  }


  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
