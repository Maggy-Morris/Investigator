part of 'camera_bloc.dart';

class CameraState extends Equatable {
  final List<String> allCameras;
  final List<GetAllCameraDetails> camerasDetails;
  final List<GetAllCameraDetails> singleCameraDetails;
  final List<List<GetAllCameraCountPerHour>> camerasCountsPerHour;
  final String selectedDay;
  final String selectedMonth;
  final String selectedYear;
  final Submission submission;

  const CameraState({
    this.submission = Submission.initial,
    this.singleCameraDetails = const [],
    this.camerasDetails = const [],
    this.allCameras = const [],
    this.camerasCountsPerHour = const [],
    this.selectedDay = "",
    this.selectedMonth = "",
    this.selectedYear = "",
  });

  CameraState copyWith({
    Submission? submission,
    List<String>? allCameras,
    List<GetAllCameraDetails>? camerasDetails,
    List<GetAllCameraDetails>? singleCameraDetails,
    List<List<GetAllCameraCountPerHour>>? camerasCountsPerHour,
    String? selectedDay,
    String? selectedMonth,
    String? selectedYear,
  }) {
    return CameraState(
      submission: submission ?? this.submission,
      singleCameraDetails: singleCameraDetails ?? this.singleCameraDetails,
      allCameras: allCameras ?? this.allCameras,
      camerasDetails: camerasDetails ?? this.camerasDetails,
      camerasCountsPerHour: camerasCountsPerHour ?? this.camerasCountsPerHour,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }

  @override
  List<Object> get props => [
        submission,
        singleCameraDetails,
        selectedDay,
        selectedMonth,
        selectedYear,
        allCameras,
        camerasDetails,
        camerasCountsPerHour,
      ];
}
