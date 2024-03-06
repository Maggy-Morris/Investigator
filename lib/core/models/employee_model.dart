import 'package:equatable/equatable.dart';

class EmployeeModel {
  List<Data>? data;

  EmployeeModel({this.data});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    try{
if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    } else {
       data = <Data>[];
    }
    }catch(e){
data = <Data>[];
    }
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? name;

  Data({this.sId, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}
