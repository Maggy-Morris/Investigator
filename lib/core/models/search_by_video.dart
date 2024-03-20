import 'package:equatable/equatable.dart';

// class SearchByVideoAndImage extends Equatable {
//   String? data;

//   SearchByVideoAndImage({
//     this.data,
//   });

//   SearchByVideoAndImage.fromJson(Map<String, dynamic> json) {
//     data = json['data'];

//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['data'] = data;

//     return data;
//   }

//   @override
//   List<Object?> get props => [
//         data,
//       ];
// }

class SearchByVideoAndImage extends Equatable {
  List<double>? data;
  bool? found;

  SearchByVideoAndImage({this.data, this.found});

  SearchByVideoAndImage.fromJson(Map<String, dynamic> json) {
    data = json['data'].cast<double>();
    found = json['Found'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['Found'] = this.found;
    return data;
  }

  @override
  List<Object?> get props => [data, found];
}
