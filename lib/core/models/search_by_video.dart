import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

class SearchByVideoAndImage extends Equatable {
  bool? found;
  List<String>? data;
  String? global_path;  
  int? response_count;


  List<String>? snapshot_list;

  SearchByVideoAndImage({this.global_path,this.response_count,this.found, this.data, this.snapshot_list});

  SearchByVideoAndImage.fromJson(Map<String, dynamic> json) {
    found = json['Found'];
    global_path = json['global_path'];
    response_count = json['response_count'];



    data = json['data'].cast<String>();
    snapshot_list = json['snapshot_list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Found'] = found;
    data['global_path'] = global_path;
    data['response_count'] = response_count;


    data['data'] = this.data;
    data['snapshot_list'] = snapshot_list;
    return data;
  }

  @override
  List<Object?> get props => [global_path,response_count,data, found, snapshot_list];
}




