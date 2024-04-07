import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

class SearchByVideoAndImage extends Equatable {
  bool? found;
  List<String>? data;
  List<String>? snapshot_list;

  SearchByVideoAndImage({this.found, this.data, this.snapshot_list});

  SearchByVideoAndImage.fromJson(Map<String, dynamic> json) {
    found = json['Found'];
    data = json['data'].cast<String>();
    snapshot_list = json['snapshot_list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Found'] = found;
    data['data'] = this.data;
    data['snapshot_list'] = snapshot_list;
    return data;
  }

  @override
  List<Object?> get props => [data, found, snapshot_list];
}

// // class SearchByVideoAndImage extends Equatable {
// //   List<double>? data;
// //   bool? found;

// //   SearchByVideoAndImage({this.data, this.found});

// //   SearchByVideoAndImage.fromJson(Map<String, dynamic> json) {
// //     data = json['data'];
// //     found = json['Found'];
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['data'] = this.data;
// //     data['Found'] = found;
// //     return data;
// //   }

// //   @override
// //   List<Object?> get props => [data, found];
// // }

// class SearchByVideoAndImage extends Equatable {
//   bool? found;
//   List<String>? data;
//  List<String>? snapshot_list;

//   SearchByVideoAndImage({this.found, this.data});

//   SearchByVideoAndImage.fromJson(Map<String, dynamic> json) {
//     found = json['Found'];
//     data = json['data'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Found'] = this.found;
//     data['data'] = this.data;
//     return data;
//   }

//   @override
//   // TODO: implement props
//   List<Object?> get props => [found, data];
// }
