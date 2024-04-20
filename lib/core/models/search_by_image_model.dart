class SearchByImageModel {
  List<List<double>>? boxes;
  List<String>? result;
  bool? targeted;
  List<Dataa>? data;
  List<String>? textAccuracy;
  List<String>? blacklis;

  SearchByImageModel(
      {this.blacklis,
      this.textAccuracy,
      this.data,
      this.boxes,
      this.result,
      this.targeted});

  SearchByImageModel.fromJson(Map<String, dynamic> json) {
    if (json['boxes'] != null) {
      boxes = (json['boxes'] as List)
          .map<List<double>>((box) =>
              (box as List).map<double>((value) => value.toDouble()).toList())
          .toList();
    }

    textAccuracy = json['confidences'] != null
        ? List<String>.from(json['confidences'])
        : null;

    if (json['data'] != []) {
      data = <Dataa>[];
      json['data'].forEach((v) {
        data?.add(Dataa.fromJson(v));
      });
    }
    blacklis =
        json['blacklisted_list_checks'] != null ? List<String>.from(json['blacklisted_list_checks']) : null;

    result = json['result'] != null ? List<String>.from(json['result']) : null;
    targeted = json['targeted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['boxes'] = boxes;
    data['confidences'] = textAccuracy;
    data['blacklisted_list_checks'] = blacklis;

    data['result'] = result;
    data['targeted'] = targeted;
    return data;
  }
}

class Dataa {
  String? sId;
  String? email;
  String? imagePath;
  String? name;
  String? phone;
  String? userId;
  String? blackListed;

  Dataa(
      {this.sId,
      this.blackListed,
      this.email,
      this.imagePath,
      this.name,
      this.phone,
      this.userId});

  Dataa.fromJson(Map<String, dynamic> json) {
    blackListed = json['blacklisted'];
    sId = json['_id'];
    email = json['email'];
    imagePath = json['image_path'];
    name = json['name'];
    phone = json['phone'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
