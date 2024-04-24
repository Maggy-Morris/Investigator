part of 'all_employess_bloc.dart';

class AllEmployeesState extends Equatable {
  final List<Data> employeeNamesList;
  final String companyName;
  String personName;
  final String image;
  final String id;
  int pageIndex;
  int pageCount;
  final Widget? imageWidget;
  bool? addingEmployee;
  final String? filterCase;

  final String selectedOption;
  final bool showTextField;
  final bool check;

  List<String> roomNAMS;

  int count;
  final String responseMessage;

  final String phoneNum;
  final String email;
  final String userId;
  final String profession;
  bool isSearching;
  final PlatformFile? imageFile;

  final Submission submission;

  AllEmployeesState({
    this.addingEmployee,
    this.check = false,
    this.roomNAMS = const [],
    this.filterCase = '',
    this.selectedOption = "",
    this.showTextField = false,
    this.imageWidget,
    this.responseMessage = "",
    this.pageCount = 0,
    this.pageIndex = 0,
    this.count = 0,
    this.imageFile,
    this.id = '',
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
  });

  AllEmployeesState copyWith({
    bool? addingEmployee,
    bool? check,
    List<String>? roomNAMS,
    String? selectedOption,
    String? filterCase,
    bool? showTextField,
    Widget? imageWidget,
    String? responseMessage,
    PlatformFile? imageFile,
    int? pageCount,
    int? pageIndex,
    int? count,
    String? id,
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
  }) {
    return AllEmployeesState(
      addingEmployee: addingEmployee ?? this.addingEmployee,
      roomNAMS: roomNAMS ?? this.roomNAMS,
      filterCase: filterCase ?? this.filterCase,
      selectedOption: selectedOption ?? this.selectedOption,
      showTextField: showTextField ?? this.showTextField,
      imageWidget: imageWidget ?? this.imageWidget,
      check: check ?? this.check,
      responseMessage: responseMessage ?? this.responseMessage,

      pageCount: pageCount ?? this.pageCount,
      count: count ?? this.count,
      imageFile: imageFile ?? this.imageFile,
      pageIndex: pageIndex ?? this.pageIndex,
      id: id ?? this.id,
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
    );
  }

  @override
  List<Object?> get props => [
        addingEmployee,
        check,
        roomNAMS,
        filterCase,
        selectedOption,
        showTextField,
        imageWidget,
        responseMessage,
        pageCount,
        id,
        isSearching,
        image,
        submission,
        imageFile,
        pageIndex,
        count,
        personName,
        companyName,
        employeeNamesList,
      ];
}
