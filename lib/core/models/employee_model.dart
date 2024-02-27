import 'package:equatable/equatable.dart';

class EmployeeModel extends Equatable {
  String? name;
  String? phone;
  String? email;

  EmployeeModel({this.name, this.phone, this.email});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    return data;
  }

  @override
  List<Object?> get props => [
        name,
        phone,
        email,
      ];
}
