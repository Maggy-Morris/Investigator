part of 'photo_app_cubit.dart';

class PhotoAppState extends Equatable {
  final bool? isLoading;
  final bool? hasError;
  final String? errorMessage;
  final String? roomChoosen;


  // final String? selectedOption;

  const PhotoAppState({
    this.roomChoosen,
    this.errorMessage,
    this.isLoading,
    this.hasError,
    // this.selectedOption,
  });

  PhotoAppState copyWith({
    
    // String? selectedOption,
    // List<List<double>>? boxes,

    List<String>? result,
    String? errorMessage,
    bool? hasError,
    bool? isLoading,
  }) {
    return PhotoAppState(

      roomChoosen: roomChoosen ?? this.roomChoosen,

      // selectedOption : selectedOption ?? this.selectedOption,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        roomChoosen,

        // selectedOption,
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
  final String? selectedOption;

  const SelectProfilePhotoState({
    this.selectedOption,
    this.file,
    super.isLoading,
    super.errorMessage,
    super.hasError,
  });

  @override
  List<Object?> get props =>
      [selectedOption, file, isLoading, errorMessage, hasError];
}

class CameraState extends PhotoAppState {
  final String? roomChoosen;
  final Submission submission;

  final CameraDescription? camera;
  final CameraController controller;
  final List<List<double>>? boxes;
  final List<String>? result;
  final bool? blacklisted;
  final bool? security_breach;
  const CameraState({
        this.submission = Submission.initial,

    this.roomChoosen,
    this.blacklisted,
    this.security_breach,
    required this.controller,
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
        Submission? submission,

    String? roomChoosen,
    bool? blacklisted,
    bool? security_breach,
    CameraController? controller,
    CameraDescription? camera,
    List<List<double>>? boxes,
    List<String>? result,
    String? errorMessage,
    bool? hasError,
    bool? isLoading,
  }) {
    return CameraState(
            submission: submission ?? this.submission,

      roomChoosen: roomChoosen ?? this.roomChoosen,
      blacklisted: blacklisted ?? this.blacklisted,
      security_breach: security_breach ?? this.security_breach,
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
            submission,

        roomChoosen,
        blacklisted,
        security_breach,
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

// class PreviewState extends PhotoAppState {
//   final File? file;

//   const PreviewState(
//       {required this.file,
//       super.isLoading,
//       super.errorMessage,
//       super.hasError});

//   @override
//   List<Object?> get props => [file, isLoading, errorMessage, hasError];
// }
