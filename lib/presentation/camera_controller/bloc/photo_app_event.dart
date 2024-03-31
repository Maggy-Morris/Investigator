part of 'photo_app_bloc.dart';

class PhotoAppEvent extends Equatable {
  const PhotoAppEvent();

  @override
  List<Object?> get props => [];
}

class OpenCameraEvent extends PhotoAppEvent {
  const OpenCameraEvent();

  @override
  List<Object?> get props => [];
}

class SwitchCameraOptions extends PhotoAppEvent {
  final bool isBackCam;
  final ResolutionPreset? resolutionPreset;

  const SwitchCameraOptions({
    required this.isBackCam,
    this.resolutionPreset,
  });

  @override
  List<Object?> get props => [isBackCam, resolutionPreset];
}

class SelectPhoto extends PhotoAppEvent {
  final File file;

  const SelectPhoto({required this.file});

  @override
  List<Object?> get props => [file];
}

class StopPeriodicPictureCapture extends PhotoAppEvent {
  const StopPeriodicPictureCapture();

  @override
  List<Object?> get props => [];
}
class StartStreamEvent extends PhotoAppEvent {
  const StartStreamEvent();

  @override
  List<Object?> get props => [];
}


