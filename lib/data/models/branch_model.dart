class BranchModel{
  String? uId;
  String? name;
  String? logo;

  BranchModel({
    required this.uId,
    required this.name,
    required this.logo,
  });

  BranchModel.fromJson(Map<String, dynamic> json) : this(
    uId: json["uId"],
    name: json["name"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() {
    return {
      "uId": uId,
      "name": name,
      "logo": logo,
    };
  }
}