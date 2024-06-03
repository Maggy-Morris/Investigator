// class historyScreenModel {
//   List<History>? data;
//   int? count;
//   int? nPages;

//   historyScreenModel({this.data});

//   historyScreenModel.fromJson(Map<String, dynamic> json) {
//     count = json['count'];
//     nPages = json['n_pages'];

//     if (json['data'] != null) {
//       data = <History>[];
//       json['data'].forEach((v) {
//         data!.add(new History.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['count'] = count;
//     data['n_pages'] = nPages;

//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class History {
//   String? function;
//   List<String>? imagePaths;
//   List<String>? persons;
//   String? timestamp;
//   String? videoPath;

//   History(
//       {this.function,
//       this.imagePaths,
//       this.persons,
//       this.timestamp,
//       this.videoPath});

//   History.fromJson(Map<String, dynamic> json) {
//     function = json['function'];
//     imagePaths = json['image_paths'].cast<String>();
//     persons = json['persons'].cast<String>();
//     timestamp = json['timestamp'];
//     videoPath = json['video_path'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['function'] = this.function;
//     data['image_paths'] = this.imagePaths;
//     data['persons'] = this.persons;
//     data['timestamp'] = this.timestamp;
//     data['video_path'] = this.videoPath;
//     return data;
//   }
// }

class historyScreenModel {
  int? count;
  List<History>? data;
  int? nPages;

  historyScreenModel({this.count, this.data, this.nPages});

  historyScreenModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = <History>[];
      json['data'].forEach((v) {
        data!.add(History.fromJson(v));
      });
    }
    nPages = json['n_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['n_pages'] = nPages;
    return data;
  }
}

class History {
  String? function;
  List<String>? imagePaths;
  List<String>? persons;
  String? timestamp;
  String? videoPath;
  String? videoUrl;

  History(
      {this.function,
      this.imagePaths,
      this.persons,
      this.timestamp,
      this.videoPath,
      this.videoUrl});

  History.fromJson(Map<String, dynamic> json) {
    function = json['function'];
    imagePaths = json['image_paths'].cast<String>();
    persons = json['persons'].cast<String>();
    timestamp = json['timestamp'];
    videoPath = json['video_path'];
    videoUrl = json['video_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['function'] = function;
    data['image_paths'] = imagePaths;
    data['persons'] = persons;
    data['timestamp'] = timestamp;
    data['video_path'] = videoPath;
    data['video_url'] = videoUrl;
    return data;
  }
}
