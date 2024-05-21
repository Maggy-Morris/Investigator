part of 'group_search_bloc.dart';

class GroupSearchState extends Equatable {
  final String pathProvided;
  final int timeDuration;
  int pageIndex;

  int pageIndexForTargets;

  
  int pageCount;
    int pageCountForTargets;

  final String selectedOption;

  final bool showTextField;
  final bool check;

  List<String> roomNAMS;
  final List<Dataaa> employeeNamesList;
  final List<String> companiesNamesList;
  final PlatformFile? video;
  final PlatformFile? imageFile;
  final Widget? imageWidget;
  List<String> snapShots;
  List<String> timestamps;

  final String accuracy;
  final Submission submission;
  final String responseMessage;

  String personName;
  final String id;

  final String phoneNum;
  final String email;
  final String userId;
  final String profession;

  final String companyName;
  String filterCase;
  final String personId;
  final List<String> data;

  GroupSearchState({
    this.timeDuration = 0,
    this.pathProvided = "",
    this.pageCount = 0,
    this.pageCountForTargets = 0,
    this.pageIndexForTargets = 0,
    this.pageIndex = 0,
    this.showTextField = false,
    this.roomNAMS = const [],
    this.check = false,
    this.selectedOption = "",
    this.responseMessage = '',
    this.id = '',
    this.phoneNum = "",
    this.email = "",
    this.profession = "",
    this.userId = "",
    this.personName = "",
    this.accuracy = '',
    this.imageWidget,
    this.timestamps = const [],
    this.snapShots = const [],
    this.data = const [],
    this.imageFile,
    this.video,
    this.filterCase = "",
    this.personId = "",
    this.companyName = "",
    this.companiesNamesList = const [],
    this.employeeNamesList = const [],
    this.submission = Submission.initial,
  });

  GroupSearchState copyWith({
    int? timeDuration,
    String? pathProvided,
    int? pageCount,
    int? pageCountForTargets,
    int? pageIndex,
    int? pageIndexForTargets,
    bool? check,
    String? selectedOption,
    List<String>? roomNAMS,
    bool? showTextField,
    String? responseMessage,
    String? id,
    String? phoneNum,
    String? email,
    String? profession,
    String? userId,
    String? personName,
    String? accuracy,
    List<String>? timestamps,
    List<String>? snapShots,
    Widget? imageWidget,
    PlatformFile? video,
    PlatformFile? imageFile,
    List<String>? companiesNamesList,
    List<Dataaa>? employeeNamesList,
    String? companyName,
    String? filterCase,
    String? personId,
    Submission? submission,
    List<String>? data,
  }) {
    return GroupSearchState(

      timeDuration: timeDuration ?? this.timeDuration,
      pathProvided: pathProvided ?? this.pathProvided,
      pageIndex: pageIndex ?? this.pageIndex,
      pageIndexForTargets : pageIndexForTargets ?? this.pageIndexForTargets,
      pageCount: pageCount ?? this.pageCount,
      pageCountForTargets:pageCountForTargets??this.pageCountForTargets,
      timestamps: timestamps ?? this.timestamps,
      roomNAMS: roomNAMS ?? this.roomNAMS,
      showTextField: showTextField ?? this.showTextField,
      check: check ?? this.check,
      selectedOption: selectedOption ?? this.selectedOption,
      responseMessage: responseMessage ?? this.responseMessage,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      profession: profession ?? this.profession,
      phoneNum: phoneNum ?? this.phoneNum,
      personName: personName ?? this.personName,
      accuracy: accuracy ?? this.accuracy,
      snapShots: snapShots ?? this.snapShots,
      imageWidget: imageWidget ?? this.imageWidget,
      data: data ?? this.data,
      video: video ?? this.video,
      imageFile: imageFile ?? this.imageFile,
      personId: personId ?? this.personId,
      filterCase: filterCase ?? this.filterCase,
      companiesNamesList: companiesNamesList ?? this.companiesNamesList,
      companyName: companyName ?? this.companyName,
      employeeNamesList: employeeNamesList ?? this.employeeNamesList,
      submission: submission ?? this.submission,
    );
  }

  @override
  List<Object?> get props => [
        timeDuration,
        pathProvided,
        pageIndex,
        pageIndexForTargets,
        pageCount,
        pageCountForTargets,
        timestamps,
        check,
        roomNAMS,
        showTextField,
        selectedOption,
        responseMessage,
        accuracy,
        email,
        phoneNum,
        profession,
        userId,
        id,
        personName,
        snapShots,
        imageWidget,
        data,
        video,
        imageFile,
        filterCase,
        personId,
        companiesNamesList,
        companyName,
        employeeNamesList,
        submission,
      ];
}
