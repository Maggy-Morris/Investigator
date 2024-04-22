part of 'group_search_bloc.dart';

class GroupSearchState extends Equatable {
  final List<Data> employeeNamesList;
  final List<String> companiesNamesList;
  final PlatformFile? video;
  final PlatformFile? imageFile;
  final Widget? imageWidget;
  List<String> snapShots;
  final String accuracy;
  final Submission submission;

  final String companyName;
  String personName;
  final String personId;
  final List<String> data;

  GroupSearchState({
    this.accuracy = '',
    this.imageWidget,
    this.snapShots = const [],
    this.data = const [],
    this.imageFile,
    this.video,
    this.personName = "",
    this.personId = "",
    this.companyName = "",
    this.companiesNamesList = const [],
    this.employeeNamesList = const [],
    this.submission = Submission.initial,
  });

  GroupSearchState copyWith({
     String? accuracy,
    List<String>? snapShots,
    Widget? imageWidget,
    PlatformFile? video,
    PlatformFile? imageFile,
    List<String>? companiesNamesList,
    List<Data>? employeeNamesList,
    String? companyName,
    String? personName,
    String? personId,
    Submission? submission,
    List<String>? data,
  }) {
    return GroupSearchState(
        accuracy :   accuracy ?? this.accuracy,
      snapShots: snapShots ?? this.snapShots,
      imageWidget: imageWidget ?? this.imageWidget,
      data: data ?? this.data,
      video: video ?? this.video,
      imageFile: imageFile ?? this.imageFile,
      personId: personId ?? this.personId,
      personName: personName ?? this.personName,
      companiesNamesList: companiesNamesList ?? this.companiesNamesList,
      companyName: companyName ?? this.companyName,
      employeeNamesList: employeeNamesList ?? this.employeeNamesList,
      submission: submission ?? this.submission,
    );
  }

  @override
  List<Object?> get props => [
    accuracy,
        snapShots,
        imageWidget,
        data,
        video,
        imageFile,
        personName,
        personId,
        companiesNamesList,
        companyName,
        employeeNamesList,
        submission,
      ];
}
