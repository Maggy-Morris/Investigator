part of 'history_bloc.dart';

class HistoryState extends Equatable {
  final String selectedDay;
  final String selectedMonth;
  final String selectedYear;



  final List<History> allHistory;
  final String videoPathForHistory;
  final int secondsGivenFromVideo;
  final PathForImages pathForImages;
  // final List<Paths> allPathes;
  final int pageIndex;
  final int pageCount;
  // final List<GetAllCameraDetails> camerasDetails;
  // final List<GetAllCameraDetails> singleCameraDetails;
  final String responseMessage;

  final String pathProvided;

  final String companyName;
  final List<String> snapShots;

  final String modelName;

  /// detail
  // final List<List<GetAllCameraCountPerHour>> camerasCountsPerHour;

  final Submission submission;
  // final List<int> videoStream;

  const HistoryState({
    this.selectedDay = "",
      this.selectedMonth = "",  this.selectedYear= "",
    this.secondsGivenFromVideo = 0,
    required this.pathForImages,
    this.videoPathForHistory = "",
    this.companyName = "",
    this.snapShots = const [],
    this.pathProvided = "",
    this.pageCount = 0,
    this.pageIndex = 0,
    this.modelName = "",
    this.responseMessage = "",
    this.submission = Submission.initial,
    // this.singleCameraDetails = const [],
    // this.camerasDetails = const [],
    // this.allPathes = const [],
    this.allHistory = const [],

    // this.vehicleCameraDetails = const [],
    // this.violenceCameraDetails = const [],
    // this.ageCameraDetails = const [],
    // this.genderCameraDetails = const [],
    // this.camerasCountsPerHour = const [],
    // this.videoStream = const [],
  });

  HistoryState copyWith({
    String? selectedDay,
    String? selectedMonth,
    String? selectedYear,


    int? secondsGivenFromVideo,
    PathForImages? pathForImages,
    String? videoPathForHistory,
    String? pathProvided,
    int? pageCount,
    int? pageIndex,
    String? companyName,
    List<String>? snapShots,
    String? modelName,
    String? responseMessage,
    Submission? submission,
    // List<Paths>? allPathes,
    List<History>? allHistory,
    // List<GetAllCameraDetails>? camerasDetails,
    // List<GetAllCameraDetails>? singleCameraDetails,
    // List<List<GetAllCameraCountPerHour>>? camerasCountsPerHour,
    // List<List<GetAllCameraCountPerHour>>? vehicleCameraDetails,
    // List<List<GetAllCameraViolencePerHour>>? violenceCameraDetails,
    // List<List<GetAllCameraAgePerHour>>? ageCameraDetails,
    // List<List<GetAllCameraGenderPerHour>>? genderCameraDetails,
    // String? selectedMinute,
    // String? selectedHour,
    // //
    // String? selectedStartDay,
    // String? selectedEndDay,
    // String? selectedDay,
    // //
    // String? selectedStartMonth,
    // String? selectedEndMonth,
    // String? selectedMonth,
    // //
    // String? selectedStartYear,
    // String? selectedEndYear,
    // String? selectedYear,
    // List<int>? videoStream,
  }) {
    return HistoryState(
      selectedDay: selectedDay ?? this.selectedDay,

      selectedMonth:selectedMonth ?? this.selectedMonth,
      selectedYear:selectedYear?? this.selectedYear,
      secondsGivenFromVideo:
          secondsGivenFromVideo ?? this.secondsGivenFromVideo,
      pathForImages: pathForImages ?? this.pathForImages,
      videoPathForHistory: videoPathForHistory ?? this.videoPathForHistory,
      allHistory: allHistory ?? this.allHistory,
      pathProvided: pathProvided ?? this.pathProvided,
      pageIndex: pageIndex ?? this.pageIndex,
      pageCount: pageCount ?? this.pageCount,
      companyName: companyName ?? this.companyName,

      snapShots: snapShots ?? this.snapShots,

      modelName: modelName ?? this.modelName,
      responseMessage: responseMessage ?? this.responseMessage,
      // vehicleCameraDetails: vehicleCameraDetails ?? this.vehicleCameraDetails,
      // ageCameraDetails: ageCameraDetails ?? this.ageCameraDetails,
      // violenceCameraDetails:
      //     violenceCameraDetails ?? this.violenceCameraDetails,
      // genderCameraDetails: genderCameraDetails ?? this.genderCameraDetails,
      // videoStream: videoStream ?? this.videoStream,
      submission: submission ?? this.submission,
      // singleCameraDetails: singleCameraDetails ?? this.singleCameraDetails,
      // allPathes: allPathes ?? this.allPathes,
      // camerasDetails: camerasDetails ?? this.camerasDetails,
      // camerasCountsPerHour: camerasCountsPerHour ?? this.camerasCountsPerHour,
    );
  }

  @override
  List<Object?> get props => [
        selectedDay,
        selectedMonth,
        selectedYear,
        
         secondsGivenFromVideo,
        pathForImages,
        videoPathForHistory,
        allHistory,
        responseMessage,
        modelName,
        pathProvided,
        snapShots,
        companyName, pageIndex,
        pageCount,

        // vehicleCameraDetails,
        // ageCameraDetails,
        // violenceCameraDetails,
        // genderCameraDetails,
        // videoStream,
        submission,
        // singleCameraDetails,

        // allPathes,
        // camerasDetails,
        // camerasCountsPerHour,
      ];
}
