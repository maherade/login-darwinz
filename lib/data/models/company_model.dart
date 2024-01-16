class CompanyModel{
  String? uId;
  String? name;
  String? logo;

  CompanyModel({
    required this.uId,
    required this.name,
    required this.logo,
  });

  CompanyModel.fromJson(Map<String, dynamic> json) : this(
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