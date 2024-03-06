part of 'all_employess_bloc.dart';

class AllEmployeesState extends Equatable {
  final List<Data> employeeNamesList;
  final String companyName;
  String personName;
  final String image;

  final List<String> allCameras;
  final List<GetAllCameraDetails> camerasDetails;
  final List<GetAllCameraDetails> singleCameraDetails;
  final List<List<GetAllCameraCountPerHour>> camerasCountsPerHour;
  final String selectedDay;
  final String selectedMonth;
  final String selectedYear;
  final Submission submission;

   AllEmployeesState({

        this.image = "",

    this.personName = "",
    this.companyName = "",
    this.employeeNamesList = const [],
    this.submission = Submission.initial,
    this.singleCameraDetails = const [],
    this.camerasDetails = const [],
    this.allCameras = const [],
    this.camerasCountsPerHour = const [],
    this.selectedDay = "",
    this.selectedMonth = "",
    this.selectedYear = "",
  });

  AllEmployeesState copyWith({
        String? image,

    List<Data>? employeeNamesList,
    String? companyName,
    String? personName,
    Submission? submission,
    List<String>? allCameras,
    List<GetAllCameraDetails>? camerasDetails,
    List<GetAllCameraDetails>? singleCameraDetails,
    List<List<GetAllCameraCountPerHour>>? camerasCountsPerHour,
    String? selectedDay,
    String? selectedMonth,
    String? selectedYear,
  }) {
    return AllEmployeesState(
            image: image ?? this.image,

      employeeNamesList: employeeNamesList ?? this.employeeNamesList,
      companyName: companyName ?? this.companyName,
      personName: personName ?? this.personName,
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
            image,

        submission,
        singleCameraDetails,
        selectedDay,
        selectedMonth,
        selectedYear,
        allCameras,
        camerasDetails,
        camerasCountsPerHour,
        personName,
        companyName,
        employeeNamesList,
      ];
}
