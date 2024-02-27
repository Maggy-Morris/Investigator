import 'package:equatable/equatable.dart';

class CallBackModel extends Equatable {
  String? data;

  CallBackModel({
    this.data,
  });

  CallBackModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = data;

    return data;
  }

  @override
  List<Object?> get props => [
        data,
      ];
}
