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




