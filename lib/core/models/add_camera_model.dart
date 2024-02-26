import 'package:equatable/equatable.dart';

class AddCameraModel extends Equatable {
  String? cameraName;
  String? sourceType;
  String? source;

  AddCameraModel({this.cameraName, this.sourceType, this.source});

  AddCameraModel.fromJson(Map<String, dynamic> json) {
    cameraName = json['cameraName'];
    sourceType = json['sourceType'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cameraName'] = cameraName;
    data['sourceType'] = sourceType;
    data['source'] = source;
    return data;
  }

  @override
  List<Object?> get props => [
        cameraName,
        sourceType,
        source,
      ];
}
