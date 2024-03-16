class SearchByImageModel {
  List<List<double>>? boxes;
  List<String>? result;
  bool? targeted;

  SearchByImageModel({this.boxes, this.result, this.targeted});

  SearchByImageModel.fromJson(Map<String, dynamic> json) {
    if (json['boxes'] != null) {
      boxes = (json['boxes'] as List)
          .map<List<double>>((box) =>
              (box as List).map<double>((value) => value.toDouble()).toList())
          .toList();
    }
    result = json['result'] != null ? List<String>.from(json['result']) : null;
    targeted = json['targeted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['boxes'] = boxes;
    data['result'] = result;
    data['targeted'] = targeted;
    return data;
  }
}
