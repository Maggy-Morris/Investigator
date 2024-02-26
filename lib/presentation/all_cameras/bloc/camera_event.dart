part of 'camera_bloc.dart';

class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => [];
}

class CameraMainDataEvent extends CameraEvent {
  const CameraMainDataEvent();

  @override
  List<Object?> get props => [];
}
class CameraInitializeDate extends CameraEvent {
  const CameraInitializeDate();

  @override
  List<Object?> get props => [];
}

// class CameraGetAllCamerasCounts extends CameraEvent {
//   const CameraGetAllCamerasCounts();
//
//   @override
//   List<Object?> get props => [];
// }

class CameraDetailsEvent extends CameraEvent {
  final String cameraName;

  const CameraDetailsEvent({required this.cameraName});

  @override
  List<Object?> get props => [cameraName];
}

class GetModelsChartsData extends CameraEvent {
  final List<String> modelsList;
  final String cameraName;

  const GetModelsChartsData({required this.modelsList,required this.cameraName});

  @override
  List<Object?> get props => [modelsList,cameraName];
}

class CameraAddDay extends CameraEvent {
  final String selectedDay;

  const CameraAddDay({required this.selectedDay});

  @override
  List<Object?> get props => [selectedDay];
}

class CameraAddMonth extends CameraEvent {
  final String selectedMonth;

  const CameraAddMonth({required this.selectedMonth});

  @override
  List<Object?> get props => [selectedMonth];
}

class CameraAddYear extends CameraEvent {
  final String selectedYear;

  const CameraAddYear({required this.selectedYear});

  @override
  List<Object?> get props => [selectedYear];
}
