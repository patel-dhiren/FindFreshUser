class Category{
  String? id;
  String name;
  String description;
  String imageUrl;
  int createdAt;

  Category({this.id, required this.name, required this.description, required this.imageUrl, required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "description": this.description,
      "imageUrl": this.imageUrl,
      "createdAt": this.createdAt,
    };
  }

  factory Category.fromJson(dynamic json) {
    return Category(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      imageUrl: json["imageUrl"],
      createdAt: json["createdAt"],
    );
  }
//
}