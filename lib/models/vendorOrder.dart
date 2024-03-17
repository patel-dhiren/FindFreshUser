

import 'package:fresh_find_user/models/address.dart';
import 'package:fresh_find_user/models/cart.dart';

class VendorOrder{
  String? orderId;
  String? userId;
  int? orderDate;
  List<Cart>? items;
  String? paymentId;
  double? totalPrice;
  String? status;
  Address? shippingAddress;

}