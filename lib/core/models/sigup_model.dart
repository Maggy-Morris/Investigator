// class signupModel {
//   // String? companyName;
//   String? logined;
//   bool? status;
//   // String? password;
//   // String? username;

//   signupModel({
//     this.status,

//     // this.companyName
//     // ,
//     this.logined,
//     // this.password,
//     // this.username
//   });

//   signupModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     // companyName = json['company_name'];
//     logined = json['logined'];
//     // password = json['password'];
//     // username = json['username'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;

//     data['logined'] = logined;
//     // data['password'] = password;
//     // data['username'] = username;
//     return data;
//   }
// }

class signupModel {
  String? logined;
  bool? status;

  signupModel({this.logined, this.status});

  signupModel.fromJson(Map<String, dynamic> json) {
    logined = json['logined'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['logined'] = logined;
    data['status'] = status;
    return data;
  }
}
