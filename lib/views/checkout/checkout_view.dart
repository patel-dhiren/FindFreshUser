import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/constants.dart';
import '../../firebase/firebase_service.dart';
import '../../models/cart.dart';
import '../../models/order_data.dart';

class CheckOutView extends StatefulWidget {
  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  double totalAmount = 0.0;
  List<Cart> cartList = [];

  void _updateQuantity(Cart cartItem, {required bool isIncrement}) async {
    double priceChange = isIncrement ? cartItem.price : -cartItem.price;

    if (isIncrement) {
      cartItem.quantity += 1;
    } else {
      if (cartItem.quantity > 1) {
        cartItem.quantity -= 1;
      }
    }

    cartItem.totalPrice = cartItem.quantity * cartItem.price;
    // Update the cart item in Firebase
    await FirebaseService().updateCartItem(cartItem);

    // Update the total amount locally without rebuilding the whole list
    setState(() {
      totalAmount += priceChange;
    });
  }

  void calculateTotalAmount() async {
    // Here, you would fetch the cart items once to calculate the initial total.
    // This is a simplified example. Adapt it to fit your actual data fetching logic.
    var cartItems = await FirebaseService().getCartItemOnce();
    setState(() {
      totalAmount = cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    });
  }

  @override
  void initState() {
    super.initState();
    calculateTotalAmount(); // Calculate the total amount initially
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check out'),
      ),
      backgroundColor: Colors.grey.shade100,
      bottomSheet: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () {
              if(totalAmount>0){
                Navigator.pushNamed(context, AppConstant.addressListView, arguments: OrderData(cartItems: cartList, totalAmount: totalAmount));
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cart is empty')));
              }
            },
            child: Text('PLACE ORDER : Rs. ${totalAmount.toStringAsFixed(2)}'),
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<Cart>>(
          stream: FirebaseService().getCartItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return _buildEmptyCart();
            } else {
              return _buildCartList(snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: ListView.builder(
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
      ),
    );
  }

  Widget _buildCartList(List<Cart> cartItems) {
    cartList = cartItems;
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
                          /*IconButton(
                            onPressed: () {
                              FirebaseService().removeCartItem(cartItem.id);
                            },
                            icon: Icon(
                              Icons.cancel_presentation_sharp,
                              color: Colors.grey,
                            ),
                          )*/
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
