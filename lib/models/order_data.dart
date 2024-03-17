

import 'package:fresh_find_user/models/address.dart';
import 'package:fresh_find_user/models/cart.dart';


class OrderData{

  List<Cart>? cartItems;
  double? totalAmount;
  Address? address;

  OrderData({this.cartItems, this.totalAmount, this.address});

}