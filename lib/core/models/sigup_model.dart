class signupModel {
  String? companyName;
  String? logined;
  String? password;
  String? username;

  signupModel({this.companyName, this.logined, this.password, this.username});

  signupModel.fromJson(Map<String, dynamic> json) {
    companyName = json['company_name'];
    logined = json['logined'];
    password = json['password'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['company_name'] = companyName;
    data['logined'] = logined;
    data['password'] = password;
    data['username'] = username;
    return data;
  }
}
