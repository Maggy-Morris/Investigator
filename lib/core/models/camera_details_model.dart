import 'package:equatable/equatable.dart';

class GetAllCameraDetails extends Equatable {
  String? cameraName;
  List<String>? models;
  CameraInfo? cameraInfo;

  GetAllCameraDetails({
    this.cameraName,
    this.models,
    this.cameraInfo,
  });

  GetAllCameraDetails.fromJson(Map<String, dynamic> json) {
    cameraName = json['Camera Name'];
    if (json['Models'] != null) {
      try {
        models = json['Models'].cast<String>();
      } catch (_) {
        models = [];
      }
      cameraInfo = json['Camera Info'] != null
          ? CameraInfo.fromJson(json['Camera Info'])
          : CameraInfo();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Camera Name'] = cameraName;
    data['Models'] = models;
    if (cameraInfo != null) {
      data['Camera Info'] = cameraInfo?.toJson();
    }
    return data;
  }

  @override
  List<Object?> get props => [
        cameraName,
        models,
        cameraInfo,
      ];
}

class CameraInfo extends Equatable {
  String? cameraName;
  String? insertionDate;
  String? insertionTimestamp;
  String? source;
  String? sourceType;
  String? status;

  CameraInfo({
    this.cameraName,
    this.insertionDate,
    this.insertionTimestamp,
    this.source,
    this.sourceType,
    this.status,
  });

  CameraInfo.fromJson(Map<String, dynamic> json) {
    cameraName = json['Camera Name'];
    insertionDate = json['Insertion Date'];
    insertionTimestamp = json['Insertion Timestamp'];
    source = json['source'].toString();
    sourceType = json['Source Type'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Camera Name'] = cameraName;
    data['Insertion Date'] = insertionDate;
    data['Insertion Timestamp'] = insertionTimestamp;
    data['source'] = source;
    data['Source Type'] = sourceType;
    data['Status'] = status;
    return data;
  }

  @override
  List<Object?> get props => [
        cameraName,
        insertionDate,
        insertionTimestamp,
        source,
        sourceType,
        status,
      ];
}
