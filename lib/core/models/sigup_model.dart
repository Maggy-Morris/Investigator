class signupModel {
  String? logined;

  signupModel({this.logined});

  signupModel.fromJson(Map<String, dynamic> json) {
    logined = json['logined'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logined'] = this.logined;
    return data;
  }
}