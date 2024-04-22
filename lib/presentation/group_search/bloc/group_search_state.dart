part of 'group_search_bloc.dart';

class GroupSearchState extends Equatable {
  final List<Dataaa> employeeNamesList;
  final List<String> companiesNamesList;
  final PlatformFile? video;
  final PlatformFile? imageFile;
  final Widget? imageWidget;
  List<String> snapShots;
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
    this.responseMessage = '',
    this.id = '',
    this.phoneNum = "",
    this.email = "",
    this.profession = "",
    this.userId = "",
    this.personName = "",
    this.accuracy = '',
    this.imageWidget,
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
    String?responseMessage,
    String? id,
    String? phoneNum,
    String? email,
    String? profession,
    String? userId,
    String? personName,
    String? accuracy,
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
      responseMessage : responseMessage ?? this.responseMessage,
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
