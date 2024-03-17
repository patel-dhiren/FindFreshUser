import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/constants.dart';
import '../../firebase/firebase_service.dart';
import '../../models/cart.dart';


class MyCartView extends StatefulWidget {
  @override
  State<MyCartView> createState() => _MyCartViewState();
}

class _MyCartViewState extends State<MyCartView> {
  void _updateQuantity(Cart cartItem, {required bool isIncrement}) async {
    if (isIncrement) {
      cartItem.quantity += 1;
    } else {
      if (cartItem.quantity > 1) {
        cartItem.quantity -= 1;
      }

    }
    cartItem.totalPrice = cartItem.quantity*cartItem.price;
    // Update the cart item in Firebase
    await FirebaseService().updateCartItem(cartItem);
    // No need to call setState() because StreamBuilder will rebuild whenever the stream updates
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart Items'),
      ),
      backgroundColor: Colors.grey.shade100,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppConstant.checkoutView);
        },
        label: Text(
          'CHECK OUT',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.shopping_basket_sharp,
          color: Colors.white,
        ),
        backgroundColor: Colors.amber,
      ),
      body: SafeArea(
        child: StreamBuilder<List<Cart>>(
          stream: FirebaseService().getCartItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return _buildEmptyCart();
            } else {
              return snapshot.data!.isEmpty ? _buildEmptyCart() : _buildCartList(snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.all(15),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.5,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 16,
                          width: MediaQuery.of(context).size.width * 0.3,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 20,
                                width: 40,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 20),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 20,
                                width: 40,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: 5,
    );
  }

  Widget _buildCartList(List<Cart> cartItems) {
    return ListView.builder(
      padding: EdgeInsets.all(15),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final Cart cartItem = cartItems[index];
        return Card(
          elevation: 0,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Image.network(
                  cartItem.imageUrl,
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              cartItem.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              FirebaseService().removeCartItem(cartItem.id);
                            },
                            icon: Icon(Icons.cancel_presentation_sharp, color: Colors.grey,),
                          )
                        ],
                      ),
                      Text(
                        "${cartItems[index].price} /${cartItems[index].unit}",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(),
                              ),
                              child: Icon(Icons.remove),
                            ),
                            onTap: () {
                              _updateQuantity(cartItem, isIncrement: false);
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Center(
                            child: Text(
                              "${cartItem.quantity}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            onTap: () {
                              _updateQuantity(cartItem, isIncrement: true);
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          Text(
                            "Rs. ${cartItem.totalPrice.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Text('Your cart is empty.'),
    );
  }
}
