import 'package:flutter/material.dart';
import 'package:fresh_find_user/models/order.dart';
import 'package:intl/intl.dart';

import '../../firebase/firebase_service.dart';

// Update this with the path to your Order model

class OrderListView extends StatefulWidget {
  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
      ),
      backgroundColor: Colors.grey.shade100,
      body: StreamBuilder<List<Order>>(
        stream: FirebaseService().orderStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading orders'));
          }

          List<Order> orders = snapshot.data ?? [];

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              Order order = orders[index];
              return Card(
                color: Colors.amber.shade50,
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text('Order ID: ${order.orderId}', style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text('User ID : ${order.userId}\nPayment ID : ${order.paymentId}\nTotal Price : ${order.totalPrice}\nStatus: ${order.status}\nShpping Address : ${order.shippingAddress!.address}, ${order.shippingAddress!.addressLine1}, ${order.shippingAddress!.addressLine2}, ${order.shippingAddress!.city}, ${order.shippingAddress!.pincode}, ${order.shippingAddress!.state}\nOrder Date : ${formatMilliseconds(order.orderDate!)}'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String formatMilliseconds(int milliseconds) {
    // Convert the milliseconds to a DateTime object
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    // Create a DateFormat object with the desired format
    DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm:ss');

    // Format the DateTime object to a string
    return formatter.format(dateTime);
  }

  void showUpdateStatusDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Order Status"),
          content: Text("Do you want to mark this order as delivered?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Done"),
              onPressed: () {
              },
            ),
          ],
        );
      },
    );
  }
}
