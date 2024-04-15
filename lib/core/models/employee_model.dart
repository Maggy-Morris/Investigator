class EmployeeModel {
  int? count;
  List<Data>? data;
  int? nPages;

  EmployeeModel({this.count, this.data, this.nPages});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    nPages = json['n_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['n_pages'] = nPages;
    return data;
  }
}

class Data {
  String? sId;
  String? email;
  String? imagePath;
  String? name;
  String? phone;
  String? userId;
  String? blackListed;

  Data({
    this.sId,
    this.email,
    this.imagePath,
    this.name,
    this.phone,
    this.userId,
    this.blackListed,
  });

  Data.fromJson(Map<String, dynamic> json) {
    blackListed = json['blacklisted'];
    sId = json['_id'];
    email = json['email'];
    imagePath = json['image_path'];
    name = json['name'];
    phone = json['phone'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blacklisted'] = blackListed;
    data['_id'] = sId;
    data['email'] = email;
    data['image_path'] = imagePath;
    data['name'] = name;
    data['phone'] = phone;
    data['user_id'] = userId;
    return data;
  }
}
