import 'package:equatable/equatable.dart';

// class EmployeeModel extends Equatable {
//   String? name;
//   String? phone;
//   String? email;

//   EmployeeModel({this.name, this.phone, this.email});

//   EmployeeModel.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     phone = json['phone'];
//     email = json['email'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['phone'] = phone;
//     data['email'] = email;
//     return data;
//   }

//   @override
//   List<Object?> get props => [
//         name,
//         phone,
//         email,
//       ];
// }

class EmployeeModel {
  List<Data>? data;

  EmployeeModel({this.data});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}
