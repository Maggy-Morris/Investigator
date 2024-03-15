class UserData {
  final String? authentication;
  final String? sId;
  final bool? login;
  final String? companyName;
  // final String? role;
  // final List<String>? companyName;

  const UserData({
    this.authentication,
    this.login,
    this.sId,
    this.companyName,
    // this.role,
  });

  UserData.fromJson(Map<String, dynamic> json)
      : authentication = json['token'],
        login = json['logined'],
        sId = json['_id'],
        companyName = json['company_name'];

  // companyName = json['companyName'].cast<String>();

  // role = json['role'];

  // name = json['name'].toString();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = authentication;
    data['logined'] = login;
    data['_id'] = sId;
    data['company_name'] = companyName;
    // data['role'] = role;
    // data['name'] = name;
    return data;
  }

  static const UserData empty = UserData(
    authentication: "",
    login: false,
    sId: "",
    companyName: "",
    // companyName: [],
    // role: "",
  );

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == UserData.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != UserData.empty;
}
