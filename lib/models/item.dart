class Item {
  String? id;
  String name;
  String description;
  double price;
  int stock;
  String unit;
  String imageUrl;
  int createdAt;
  String vendorId;
  String vendorName;
  String city;
  String vendorBusinessName;

  Item(
      {this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.stock,
      required this.unit,
      required this.imageUrl,
      required this.vendorId,
      required this.vendorName,
      required this.vendorBusinessName,
      required this.city,
      required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "description": this.description,
      "price": this.price,
      "stock": this.stock,
      "unit": this.unit,
      "imageUrl": this.imageUrl,
      "vendorId": this.vendorId,
      "vendorName": this.vendorName,
      "vendorBusinessName": this.vendorBusinessName,
      "city": this.city,
      "createdAt": this.createdAt,
    };
  }

  factory Item.fromJson(Map<dynamic, dynamic> json) {
    return Item(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      price: double.parse(json["price"].toString()),
      stock: json["stock"],
      unit: json["unit"],
      imageUrl: json["imageUrl"],
      vendorId: json["vendorId"],
      vendorName: json["vendorName"],
      vendorBusinessName: json["vendorBusinessName"],
      city: json["city"],
      createdAt: json["createdAt"],
    );
  }
//
}
