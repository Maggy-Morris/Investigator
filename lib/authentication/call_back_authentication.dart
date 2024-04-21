class UserData {
  final String? token;
  final String? sId;
  final bool? logined;
  final String? username;

  final int? nRooms;
  final List<String>? roomsNames; // final String? companyName;
  // final String? role;
  final List<dynamic>? companyName;

  const UserData({
    this.token,
    this.username,
    this.logined,
    this.sId,
    this.companyName,
    this.nRooms,
    this.roomsNames,
    // this.role,
  });

  UserData copyWith({
    String? token,
    String? sId,
    bool? logined,
    String? username,
    int? nRooms,
    List<String>? roomsNames, // final String? companyName;
    // final String? role;
    List<dynamic>? companyName,
  }) {
    return UserData(
      token: token ?? this.token,
      sId: sId ?? this.sId,
      logined: logined ?? this.logined,
      username: username ?? this.username,
      nRooms: nRooms ?? this.nRooms,
      roomsNames: roomsNames ?? this.roomsNames,
      companyName: companyName ?? this.companyName,
    );
  }

  UserData.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        username = json['username'],
        nRooms = json['n_rooms'],
        roomsNames = json['rooms_names'].cast<String>(),
        logined = json['logined'],
        sId = json['_id'],
        companyName = json['company_name'];

  // companyName = json['companyName'].cast<String>();

  // role = json['role'];

  // name = json['name'].toString();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['logined'] = logined;
    data['_id'] = sId;
    data['username'] = username;

    data['company_name'] = companyName;
    data['n_rooms'] = nRooms;
    data['rooms_names'] = roomsNames;
    // data['role'] = role;
    // data['name'] = name;
    return data;
  }

  static const UserData empty = UserData(
    token: "",
    logined: false,
    sId: "",
    username: '',
    roomsNames: [],
    nRooms: 0,
    // companyName: "",
    companyName: [],
    // role: "",
  );

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == UserData.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != UserData.empty;
}

// class UserData {
//   final String? sId;
//   final String? username;
//   final List<String>? companyName;
//   final bool? logined;
//   final int? nRooms;
//   final List<String>? roomsNames;
//   final String? token;

//   const UserData(
//       {this.sId,
//       this.username,
//       this.companyName,
//       this.logined,
//       this.nRooms,
//       this.roomsNames,
//       this.token});

//   UserData.fromJson(Map<String, dynamic> json)
//       : sId = json['_id'],
//         username = json['username'],
//         companyName = json['company_name'].cast<String>(),
//         logined = json['logined'],
//         nRooms = json['n_rooms'],
//         roomsNames = json['rooms_names'].cast<String>(),
//         token = json['token'];

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['_id'] = sId;
//     data['username'] = username;
//     data['company_name'] = companyName;
//     data['logined'] = logined;
//     data['n_rooms'] = nRooms;
//     data['rooms_names'] = roomsNames;
//     data['token'] = token;
//     return data;
//   }

//   static const UserData empty = UserData(
//     // authentication: "",
//     logined: false,
//     sId: "",
//     username: '',
//     // companyName: "",
//     companyName: [],
//     // role: "",
//   );

//   /// Convenience getter to determine whether the current user is empty.
//   bool get isEmpty => this == UserData.empty;

//   /// Convenience getter to determine whether the current user is not empty.
//   bool get isNotEmpty => this != UserData.empty;
// }
