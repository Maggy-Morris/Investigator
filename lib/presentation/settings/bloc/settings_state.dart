part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final List<Data> employeeNamesList;
  final String companyName;
  String passwordUpdate;
  String oldpassword;
  final String roomNames;
  final String rooms;

  final String image;
  final String id;
  int pageIndex;
  int pageCount;
  final Widget? imageWidget;
  final String selectedOption;
  final bool showTextField;
  final bool check;
  int room_numbers;

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

  SettingsState({
    this.rooms = "",
    this.roomNames = "",
    this.check = false,
    this.roomNAMS = const [],
    this.selectedOption = "",
    this.showTextField = false,
    this.imageWidget,
    this.responseMessage = "",
    this.pageCount = 0,
    this.pageIndex = 0,
    this.room_numbers = 0,
    this.count = 0,
    this.imageFile,
    this.id = '',
    this.phoneNum = "",
    this.email = "",
    this.profession = "",
    this.userId = "",
    this.isSearching = false,
    this.image = "",
    this.passwordUpdate = "",
    this.oldpassword = "",
    this.companyName = "",
    this.employeeNamesList = const [],
    this.submission = Submission.initial,
  });

  SettingsState copyWith({
    bool? check,
    List<String>? roomNAMS,
    String? selectedOption,
    String? roomNames,
    String? rooms,
    bool? showTextField,
    Widget? imageWidget,
    String? responseMessage,
    PlatformFile? imageFile,
    int? pageCount,
    int? pageIndex,
    int? room_numbers,
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
    String? passwordUpdate,
    String? oldpassword,
    Submission? submission,
  }) {
    return SettingsState(
      rooms: rooms ?? this.rooms,
      roomNames: roomNames ?? this.roomNames,
      room_numbers: room_numbers ?? this.room_numbers,
      roomNAMS: roomNAMS ?? this.roomNAMS,
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
      passwordUpdate: passwordUpdate ?? this.passwordUpdate,

      oldpassword: oldpassword ?? this.oldpassword,
      submission: submission ?? this.submission,
    );
  }

  @override
  List<Object?> get props => [
        rooms,
        roomNames,
        room_numbers,
        check,
        roomNAMS,
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
        passwordUpdate,
        oldpassword,
        companyName,
        employeeNamesList,
      ];
}
