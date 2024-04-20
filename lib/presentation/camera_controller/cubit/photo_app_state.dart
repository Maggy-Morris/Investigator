// part of 'photo_app_cubit.dart';

// class PhotoAppState extends Equatable {
//   final bool? isLoading;
//   final bool? hasError;
//   final String? errorMessage;
//   final String? roomChoosen;
//   final bool? isChosen;

//   // final String? selectedOption;

//   const PhotoAppState({
//     this.isChosen,
//     this.roomChoosen,
//     this.errorMessage,
//     this.isLoading,
//     this.hasError,
//     // this.selectedOption,
//   });

//   PhotoAppState copyWith({
//     // bool? isChosen,
//     // String? selectedOption,
//     // List<List<double>>? boxes,

//     List<String>? result,
//     String? errorMessage,
//     bool? hasError,
//     bool? isLoading,
//   }) {
//     return PhotoAppState(
//       isChosen: isChosen ?? this.isChosen,
//       roomChoosen: roomChoosen ?? this.roomChoosen,

//       // selectedOption : selectedOption ?? this.selectedOption,
//       isLoading: isLoading ?? this.isLoading,
//       hasError: hasError ?? this.hasError,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         roomChoosen,
//         isChosen,
//         // selectedOption,
//         isLoading,
//         errorMessage,
//         hasError,
//       ];
// }

// class InitialState extends PhotoAppState {
//   const InitialState();
//   @override
//   List<Object?> get props => [];
// }

// class SelectProfilePhotoState extends PhotoAppState {
//   final File? file;
//   final String? selectedOption;

//   const SelectProfilePhotoState({
//     this.selectedOption,
//     this.file,
//     super.isLoading,
//     super.errorMessage,
//     super.hasError,
//   });

//   @override
//   List<Object?> get props =>
//       [selectedOption, file, isLoading, errorMessage, hasError];
// }

// class CameraState extends PhotoAppState {
//   final String? roomChoosen;
//   final Submission submission;
//   final bool? securityBreachChecked;
//   final CameraDescription? camera;
//   final CameraController controller;
//   final List<List<double>>? boxes;
//   final List<String>? result;
//   final bool? blacklisted;
//   final bool? security_breach;
//   const CameraState({
//     this.securityBreachChecked,
//     this.submission = Submission.initial,
//     this.roomChoosen,
//     this.blacklisted,
//     this.security_breach,
//     required this.controller,
//     this.camera,
//     this.boxes,
//     this.result,
//     super.isLoading,
//     super.hasError,
//     String? errorMessage,
//   }) : super(
//           errorMessage: errorMessage,
//         );

//   @override
//   CameraState copyWith({
//     bool? securityBreachChecked,
//     Submission? submission,
//     String? roomChoosen,
//     bool? blacklisted,
//     bool? security_breach,
//     CameraController? controller,
//     CameraDescription? camera,
//     List<List<double>>? boxes,
//     List<String>? result,
//     String? errorMessage,
//     bool? hasError,
//     bool? isLoading,
//   }) {
//     return CameraState(
//       securityBreachChecked:
//           securityBreachChecked ?? this.securityBreachChecked,
//       submission: submission ?? this.submission,
//       roomChoosen: roomChoosen ?? this.roomChoosen,
//       blacklisted: blacklisted ?? this.blacklisted,
//       security_breach: security_breach ?? this.security_breach,
//       controller: controller ?? this.controller,
//       camera: camera ?? this.camera,
//       result: result ?? this.result,
//       boxes: boxes ?? this.boxes,
//       isLoading: isLoading ?? this.isLoading,
//       hasError: hasError ?? this.hasError,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         securityBreachChecked,
//         submission,
//         roomChoosen,
//         blacklisted,
//         security_breach,
//         result,
//         boxes,
//         controller,
//         camera,
//         isLoading,
//         errorMessage,
//         hasError,
//       ];
// }

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

// /////////////////////////////////////////////////////////////////

part of 'photo_app_cubit.dart';

class PhotoAppState extends Equatable {
  final List<String>? textAccuracy;

  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final String? roomChoosen;
  final bool isChosen;
  final File? file;
  final String? selectedOption;
  final List<String>? blacklisted_list_checks;

  final String? sliderValue;

  final bool securityBreachChecked;
  final Submission submission;
  final CameraDescription? camera;
  final CameraController? controller;
  final List<List<double>>? boxes;
  final List<String>? result;
  final bool? blacklisted;
  final bool? securityBreach;

  const PhotoAppState({
    this.blacklisted_list_checks,
    this.textAccuracy,
    required this.isLoading,
    required this.hasError,
    this.sliderValue,
    this.errorMessage,
    this.roomChoosen,
    required this.isChosen,
    this.file,
    this.selectedOption,
    required this.securityBreachChecked,
    required this.submission,
    this.camera,
    required this.controller,
    this.boxes,
    this.result,
    this.blacklisted,
    this.securityBreach,
  });

  @override
  List<Object?> get props => [
        blacklisted_list_checks,
        textAccuracy,
        sliderValue,
        roomChoosen,
        isChosen,
        errorMessage,
        isLoading,
        hasError,
        file,
        selectedOption,
        securityBreachChecked,
        submission,
        camera,
        controller,
        boxes,
        result,
        blacklisted,
        securityBreach,
      ];

  PhotoAppState copyWith({
    List<String>? textAccuracy,
    List<String>? blacklisted_list_checks,
    String? sliderValue,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    String? roomChoosen,
    bool? isChosen,
    File? file,
    String? selectedOption,
    bool? securityBreachChecked,
    Submission? submission,
    CameraDescription? camera,
    CameraController? controller,
    List<List<double>>? boxes,
    List<String>? result,
    bool? blacklisted,
    bool? securityBreach,
  }) {
    return PhotoAppState(
      blacklisted_list_checks: blacklisted_list_checks ?? this.blacklisted_list_checks,
      textAccuracy: textAccuracy ?? this.textAccuracy,
      sliderValue: sliderValue ?? this.sliderValue,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      roomChoosen: roomChoosen ?? this.roomChoosen,
      isChosen: isChosen ?? this.isChosen,
      file: file ?? this.file,
      selectedOption: selectedOption ?? this.selectedOption,
      securityBreachChecked:
          securityBreachChecked ?? this.securityBreachChecked,
      submission: submission ?? this.submission,
      camera: camera ?? this.camera,
      controller: controller ?? this.controller,
      boxes: boxes ?? this.boxes,
      result: result ?? this.result,
      blacklisted: blacklisted ?? this.blacklisted,
      securityBreach: securityBreach ?? this.securityBreach,
    );
  }
}
