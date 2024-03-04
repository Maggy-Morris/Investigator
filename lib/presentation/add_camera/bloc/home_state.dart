part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<Data> employeeNamesList;
  final List<String> companiesNamesList;
  final PlatformFile? files;
  final String image;

  final Submission submission;

  final String companyName;
  final String personName;
  final String personId;

  const HomeState({
    this.image = "",
    this.files,
    this.personName = "",
    this.personId = "",
    this.companyName = "",
    this.companiesNamesList = const [],
    this.employeeNamesList = const [],
    this.submission = Submission.initial,
  });

  HomeState copyWith({
    String? image,
    PlatformFile? files,
    List<String>? companiesNamesList,
    List<Data>? employeeNamesList,
    String? companyName,
    String? personName,
    String? personId,
    Submission? submission,
  }) {
    return HomeState(
      image: image ?? this.image,
      files: files ?? this.files,
      personId: personId ?? this.personId,
      personName: personName ?? this.personName,
      companiesNamesList: companiesNamesList ?? this.companiesNamesList,
      companyName: companyName ?? this.companyName,
      employeeNamesList: employeeNamesList ?? this.employeeNamesList,
      submission: submission ?? this.submission,
    );
  }

  @override
  List<Object> get props => [
        // files ?? PlatformFile(), // Provide a default value if files is null
        image,
        if (files != null) files!,
        personName,
        personId,
        companiesNamesList,
        companyName,
        employeeNamesList,

        submission,
      ];
}
