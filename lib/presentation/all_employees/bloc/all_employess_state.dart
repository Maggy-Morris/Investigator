part of 'all_employess_bloc.dart';

class AllEmployeesState extends Equatable {
  final List<Data> employeeNamesList;
  final String companyName;
  String personName;
  final String image;

  final String phoneNum;
  final String email;
  final String userId;
  final String profession;
  bool isSearching;

  final List<String> allCameras;
  final List<GetAllCameraDetails> camerasDetails;
  final List<GetAllCameraDetails> singleCameraDetails;
  final List<List<GetAllCameraCountPerHour>> camerasCountsPerHour;
  final String selectedDay;
  final String selectedMonth;
  final String selectedYear;
  final Submission submission;

  AllEmployeesState({
    this.phoneNum = "",
    this.email = "",
    this.profession = "",
    this.userId = "",
    this.isSearching = false,
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
    String? phoneNum,
    String? email,
    String? profession,
    String? userId,
    bool? isSearching,
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
      userId: userId ?? this.userId,
      email: email ?? this.email,
      profession: profession ?? this.profession,
      phoneNum: phoneNum ?? this.phoneNum,

      ////////////////////////////////////
      isSearching: isSearching ?? this.isSearching,
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
        isSearching,
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
