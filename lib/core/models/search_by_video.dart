import 'package:equatable/equatable.dart';

class SearchByVideoAndImage extends Equatable {
  bool? found;
  List<String>? data;

  SearchByVideoAndImage({this.found, this.data});

  SearchByVideoAndImage.fromJson(Map<String, dynamic> json) {
    found = json['Found'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Found'] = found;
    data['data'] = this.data;
    return data;
  }

  @override
  List<Object?> get props => [data, found];
}

// class SearchByVideoAndImage extends Equatable {
//   List<double>? data;
//   bool? found;

//   SearchByVideoAndImage({this.data, this.found});

//   SearchByVideoAndImage.fromJson(Map<String, dynamic> json) {
//     data = json['data'];
//     found = json['Found'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['data'] = this.data;
//     data['Found'] = found;
//     return data;
//   }

//   @override
//   List<Object?> get props => [data, found];
// }
