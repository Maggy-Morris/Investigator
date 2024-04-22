class UpdatePasswordModel {
  bool? updated;
  String? data;

  UpdatePasswordModel({this.updated, this.data});

  UpdatePasswordModel.fromJson(Map<String, dynamic> json) {
    updated = json['updated'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['updated'] = this.updated;
    data['data'] = this.data;
    return data;
  }
}