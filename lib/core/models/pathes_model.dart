class pathes_model {
  List<Paths>? paths;

  pathes_model({this.paths});

  pathes_model.fromJson(Map<String, dynamic> json) {
    if (json['paths'] != null) {
      paths = <Paths>[];
      json['paths'].forEach((v) {
        paths!.add(Paths.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (paths != null) {
      data['paths'] = paths!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Paths {
  int? count;
  String? path;

  Paths({this.count, this.path});

  Paths.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['count'] = count;
    data['path'] = path;
    return data;
  }
}
