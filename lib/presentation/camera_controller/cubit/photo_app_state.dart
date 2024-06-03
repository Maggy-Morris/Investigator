
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

  final String? accuracy;
  final double sliderValue;

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
    this.accuracy,
    this.sliderValue = 10.0,
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
        accuracy,
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
    String? accuracy,
    double? sliderValue,
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
      accuracy: accuracy ?? this.accuracy,
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
