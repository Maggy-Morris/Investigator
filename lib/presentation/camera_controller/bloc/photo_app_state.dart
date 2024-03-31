part of 'photo_app_bloc.dart';

// sealed class PhotoAppState extends Equatable {
//   const PhotoAppState();
  
//   @override
//   List<Object> get props => [];
// }

// final class PhotoAppInitial extends PhotoAppState {}


class PhotoAppState extends Equatable {
  final bool? isLoading;
  final bool? hasError;
  final String? errorMessage;

  

  const PhotoAppState({
    this.errorMessage,
    this.isLoading,
    this.hasError,
  });

  PhotoAppState copyWith({
    List<List<double>>? boxes,
    List<String>? result,
    String? errorMessage,
    bool? hasError,
    bool? isLoading,
  }) {
    return PhotoAppState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        hasError,
      ];
}

class InitialState extends PhotoAppState {
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
  List<Object?> get props => [file, isLoading, errorMessage, hasError];
}

class CameraState extends PhotoAppState {
  final CameraDescription? camera;
  final CameraController? controller;
  final List<List<double>>? boxes;
  final List<String>? result;

  const CameraState({
    this.controller,
    this.camera,
    this.boxes,
    this.result,
    super.isLoading,
    super.hasError,
    String? errorMessage,
  }) : super(
          errorMessage: errorMessage,
        );

  @override
  CameraState copyWith({
    CameraController? controller,
    CameraDescription? camera,
    List<List<double>>? boxes,
    List<String>? result,
    String? errorMessage,
    bool? hasError,
    bool? isLoading,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      camera: camera ?? this.camera,
      result: result ?? this.result,
      boxes: boxes ?? this.boxes,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        result,
        boxes,
        controller,
        camera,
        isLoading,
        errorMessage,
        hasError,
      ];
}

// class CameraState extends PhotoAppState {
//   final CameraDescription camera;
//   final CameraController controller;

// final List<List<double>>? boxes;
//  final List<String>? result;

//   const CameraState({
//      required this.controller,
//      required this.camera,
//     super.isLoading,
//     super.errorMessage,
//     super.hasError,
//         this.result,
//   this.boxes,
//   });

//   @override
//   CameraState copyWith({
//     CameraController? controller,
// CameraDescription? camera  ,

//     List<List<double>>? boxes,
//     List<String>? result,
//     String? errorMessage,
//     bool? hasError,
//      bool? isLoading,

//   }) {
//     return CameraState(
//       controller : controller ?? this.controller,
//       camera : camera ?? this.camera,
//       result: result ?? this.result,
//       boxes: boxes ?? this.boxes,
//       isLoading : isLoading ?? this.isLoading,
//      hasError : hasError ?? this.hasError,
//       errorMessage : errorMessage?? this.errorMessage,
//     );
//     }

//   @override
//   List<Object?> get props => [result,boxes,controller, camera, isLoading, errorMessage, hasError];
// }

class PreviewState extends PhotoAppState {
  final File? file;

  const PreviewState(
      {required this.file,
      super.isLoading,
      super.errorMessage,
      super.hasError});

  @override
  List<Object?> get props => [file, isLoading, errorMessage, hasError];
}
