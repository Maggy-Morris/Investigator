part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class DataEvent extends HomeEvent {
  const DataEvent();

  @override
  List<Object?> get props => [];
}

class GetCamerasNames extends HomeEvent {
  const GetCamerasNames();

  @override
  List<Object?> get props => [];
}

class GetSourceTypes extends HomeEvent {
  const GetSourceTypes();

  @override
  List<Object?> get props => [];
}

class GetModelsName extends HomeEvent {
  const GetModelsName();

  @override
  List<Object?> get props => [];
}

/// handle state events
class AddCameraName extends HomeEvent {
  final String cameraName;

  const AddCameraName({required this.cameraName});

  @override
  List<Object?> get props => [cameraName];
}

class AddCameraSource extends HomeEvent {
  final String cameraSource;

  const AddCameraSource({required this.cameraSource});

  @override
  List<Object?> get props => [cameraSource];
}

class AddCameraSourceType extends HomeEvent {
  final String cameraSourceType;

  const AddCameraSourceType({required this.cameraSourceType});

  @override
  List<Object?> get props => [cameraSourceType];
}

class AddCameraSourceModels extends HomeEvent {
  final List<String> cameraSelectedModels;

  const AddCameraSourceModels({required this.cameraSelectedModels});

  @override
  List<Object?> get props => [cameraSelectedModels];
}

/// add camera event
class AddCameraEvent extends HomeEvent {
  const AddCameraEvent();

  @override
  List<Object?> get props => [];
}

/// apply model event
class ApplyModelEvent extends HomeEvent {
  // final String cameraName;
  // final List<String> modelName;

  const ApplyModelEvent(
  //     {
  //   required this.modelName,
  //   required this.cameraName,
  // }
  );

  @override
  List<Object?> get props => [
        // cameraName,
        // modelName,
      ];
}
