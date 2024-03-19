class UserData {
  String id;
  String contact;
  String name;
  String email;
  int createdAt;
  bool isActive;

  UserData(
      {required this.id,
      required this.contact,
      required this.name,
      required this.email,
      required this.createdAt,
      this.isActive = true});

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "contact": this.contact,
      "name": this.name,
      "email": this.email,
      "createdAt": this.createdAt,
      "isActive": this.isActive,
    };
  }

  factory UserData.fromJson(dynamic json) {
    return UserData(
      id: json["id"],
      contact: json["contact"],
      name: json["name"],
      email: json["email"],
      createdAt: json["createdAt"],
      isActive: json["isActive"],
    );
  }
//
}
