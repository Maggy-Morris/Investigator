class UpdateModel {
  bool? updated;

  UpdateModel({this.updated});

  UpdateModel.fromJson(Map<String, dynamic> json) {
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['updated'] = updated;
    return data;
  }
}
