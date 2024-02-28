part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<String> camerasNamesList;
  final List<String> employeeNamesList;
  final List<String> companiesNamesList;

  final List<String> sourceTypesList;
  final List<String> modelsNameList;
  final Submission submission;

  final List<String> cameraSelectedModels;
  final String companyName;
  final String personName;
  final String personId;

  final String cameraName;
  final String cameraSource;
  final String cameraSourceType;

  const HomeState({
    this.personName = "",
    this.personId = "",
    this.companyName = "",
    this.companiesNamesList = const [],
    this.employeeNamesList = const [],
    this.camerasNamesList = const [],
    this.sourceTypesList = const [],
    this.modelsNameList = const [],
    this.cameraSelectedModels = const [],
    this.cameraName = "",
    this.cameraSource = "",
    this.cameraSourceType = "",
    this.submission = Submission.initial,
  });

  HomeState copyWith({
    List<String>? companiesNamesList,
    List<String>? employeeNamesList,
    String? companyName,
    String? personName,
    String? personId,
    List<String>? camerasNamesList,
    List<String>? sourceTypesList,
    List<String>? modelsNameList,
    List<String>? cameraSelectedModels,
    String? cameraName,
    String? cameraSource,
    String? cameraSourceType,
    Submission? submission,
  }) {
    return HomeState(
      personId: personId ?? this.personId,
      personName: personName ?? this.personName,
      companiesNamesList: companiesNamesList ?? this.companiesNamesList,
      companyName: companyName ?? this.companyName,
      employeeNamesList: employeeNamesList ?? this.employeeNamesList,
      camerasNamesList: camerasNamesList ?? this.camerasNamesList,
      sourceTypesList: sourceTypesList ?? this.sourceTypesList,
      modelsNameList: modelsNameList ?? this.modelsNameList,
      cameraName: cameraName ?? this.cameraName,
      cameraSource: cameraSource ?? this.cameraSource,
      cameraSourceType: cameraSourceType ?? this.cameraSourceType,
      cameraSelectedModels: cameraSelectedModels ?? this.cameraSelectedModels,
      submission: submission ?? this.submission,
    );
  }

  @override
  List<Object> get props => [
        personName,
        personId,
        companiesNamesList,
        companyName,
        employeeNamesList,
        camerasNamesList,
        sourceTypesList,
        modelsNameList,
        cameraName,
        cameraSource,
        cameraSourceType,
        cameraSelectedModels,
        submission,
      ];
}
