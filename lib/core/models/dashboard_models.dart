import 'package:equatable/equatable.dart';

class GetAllCameraCount extends Equatable {
  String? cameraName;
  int? countAverage;
  String? model;

  GetAllCameraCount({this.cameraName, this.countAverage, this.model});

  GetAllCameraCount.fromJson(Map<String, dynamic> json) {
    cameraName = json['Camera Name'];
    countAverage = json['Count Average'];
    model = json['Model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Camera Name'] = cameraName;
    data['Count Average'] = countAverage;
    data['Model'] = model;
    return data;
  }

  @override
  List<Object?> get props => [
        cameraName,
        countAverage,
        model,
      ];
}

class GetAllCameraCountPerHour extends Equatable {
  String? cameraName;
  int? countAverage;
  String? model;
  String? timeRange;

  GetAllCameraCountPerHour({
    this.cameraName,
    this.countAverage,
    this.model,
    this.timeRange,
  });

  GetAllCameraCountPerHour.fromJson(Map<String, dynamic> json) {
    cameraName = json['Camera Name'];
    countAverage = json['Count Average'];
    model = json['Model'];
    timeRange = json['Time Range'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Camera Name'] = cameraName;
    data['Count Average'] = countAverage;
    data['Model'] = model;
    data['Time Range'] = timeRange;
    return data;
  }

  @override
  List<Object?> get props => [
        cameraName,
        countAverage,
        model,
        timeRange,
      ];
}
