import 'package:fresh_find_user/models/address.dart';
import 'package:fresh_find_user/models/cart.dart';

class Order {
  String? orderId;
  String? userId;
  int? orderDate;
  List<Cart>? items;
  String? paymentId;
  double? totalPrice;
  String? status;
  Address? shippingAddress;

  Order(
      {this.orderId,
      this.userId,
      this.orderDate,
      this.items,
      this.paymentId,
      this.totalPrice,
      this.status,
      this.shippingAddress});

  Map<dynamic, dynamic> toJson() {
    return {
      "orderId": orderId,
      "userId": userId,
      "orderDate": orderDate,
      "items": items?.map((item) => item.toJson()).toList(),
      "paymentId": paymentId,
      "totalPrice": totalPrice,
      "status": status,
      "shippingAddress": shippingAddress?.toJson(),
    };
  }

  static Order fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      userId: json['userId'],
      orderDate: json['orderDate'],
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => Cart.fromJson(item))
          .toList(),
      paymentId: json['paymentId'],
      totalPrice: double.parse(json['totalPrice'].toString()),
      status: json['status'],
      shippingAddress: json['shippingAddress'] != null
          ? Address.fromJson(json['shippingAddress'])
          : null,
    );
  }

  Map<String, dynamic> toVendorSpecificOrdersJson() {
    Map<String, dynamic> vendorOrdersData = {};
    items?.forEach((item) {
      String vendorId = item.vendorId;
      vendorOrdersData[vendorId] = vendorOrdersData[vendorId] ?? {};
      vendorOrdersData[vendorId][orderId!] =
          vendorOrdersData[vendorId][orderId!] ??
              {
                'items': [],
                'orderId': orderId,
                'paymentId': paymentId,
                'userId' : userId,
                'orderDate' : orderDate,
                'status' : status,
                "shippingAddress": shippingAddress?.toJson(),
              };
      vendorOrdersData[vendorId][orderId!]['items'].add(item.toJson());
    });
    return vendorOrdersData;
  }
}
