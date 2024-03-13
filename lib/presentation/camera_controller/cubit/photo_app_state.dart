part of 'photo_app_cubit.dart';

abstract class PhotoAppState extends Equatable {
  final bool? isLoading;
  final bool? hasError;
  final String? errorMessage;

  const PhotoAppState({
    this.errorMessage,
    this.isLoading,
    this.hasError
  });
}


class InitialState extends PhotoAppState{
  const InitialState();
  @override
  List<Object?> get props => [];
}


class SelectProfilePhotoState extends PhotoAppState {
  final File? file;

  const SelectProfilePhotoState({
    this.file,
    super.isLoading,
    super.errorMessage,
    super.hasError,
  });

  @override
  List<Object?> get props =>[file, isLoading, errorMessage, hasError];
 }

class CameraState extends PhotoAppState {
  final CameraDescription camera;
  final CameraController controller;

  const CameraState({
    required this.controller,
    required this.camera,
    super.isLoading,
    super.errorMessage,
    super.hasError,
  });

  @override
  List<Object?> get props => [controller, camera, isLoading, errorMessage, hasError];
}

class PreviewState extends PhotoAppState {
  final File? file;

  const PreviewState({
    required this.file,
    super.isLoading,
    super.errorMessage,
    super.hasError
  });

  @override
  List<Object?> get props => [file, isLoading, errorMessage, hasError];
}