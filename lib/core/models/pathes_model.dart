import 'dart:convert';

class pathes_model {
  PathForImages? data;

  pathes_model({this.data});

  pathes_model.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ?  PathForImages.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}



class PathForImages {
  final int? count;
  final String? filePath;
  final List<String>? timestamp;

  PathForImages({required this.count, required this.filePath, required this.timestamp});

  PathForImages.fromJson(Map<String, dynamic> json)
      : count = json['count'],
        filePath = json['file_path'],
        timestamp = json['timestamp'].cast<String>();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['count'] = count;
    data['file_path'] = filePath;
    data['timestamp'] = timestamp;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  static PathForImages fromString(String jsonString) {
    return PathForImages.fromJson(jsonDecode(jsonString));
  }
}
