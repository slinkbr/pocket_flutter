class Users {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? avatar;
  bool? admin;

  Users({
    this.id,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.avatar,
    this.admin,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        avatar: json["avatar"],
        admin: json["admin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "avatar": avatar,
        "admin": admin,
      };
}
