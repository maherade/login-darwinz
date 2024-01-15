class UserModel {
  static const String collectionName = 'Users';
  String? uId;
  String? name;
  String? email;

  UserModel({
    required this.uId,
    required this.name,
    required this.email,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
    uId: json["uId"],
    name: json["name"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() {
    return {
      "uId": uId,
      "name": name,
      "email": email,
    };
  }
}
