class UserData {
  final String? authentication;
  // final String? sId;
  // final String? role;
  final bool? login;

  const UserData({
    this.authentication,
    this.login,
    // this.sId,
    // this.role,
  });

  UserData.fromJson(Map<String, dynamic> json)
      : authentication = json['token'],
        login = json['logined'];
        // sId = json['_id'],
        // role = json['role'];

  // name = json['name'].toString();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = authentication;
    data['logined'] = login;
    // data['_id'] = sId;
    // data['role'] = role;
    // data['name'] = name;
    return data;
  }

  static const UserData empty = UserData(
    authentication: "",
    login: false,
    // sId: "",
    // role: "",
  );

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == UserData.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != UserData.empty;
}
