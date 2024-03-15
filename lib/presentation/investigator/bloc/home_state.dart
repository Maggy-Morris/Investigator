part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<Data> employeeNamesList;
  final List<String> companiesNamesList;
  final PlatformFile? video;
  final PlatformFile? imageFile;

  final Submission submission;

  final String companyName;
  String personName;
  final String personId;

  HomeState({
    this.imageFile ,
    this.video ,
    this.personName = "",
    this.personId = "",
    this.companyName = "",
    this.companiesNamesList = const [],
    this.employeeNamesList = const [],
    this.submission = Submission.initial,
  });

  HomeState copyWith({
    PlatformFile? video,
    PlatformFile? imageFile,
    List<String>? companiesNamesList,
    List<Data>? employeeNamesList,
    String? companyName,
    String? personName,
    String? personId,
    Submission? submission,
  }) {
    return HomeState(
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
