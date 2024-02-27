part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<String> camerasNamesList;
  final List<String> companyNamesList;

  final List<String> sourceTypesList;
  final List<String> modelsNameList;
  final Submission submission;

  final List<String> cameraSelectedModels;
  final String companyName;

  final String cameraName;
  final String cameraSource;
  final String cameraSourceType;

  const HomeState({
    this.companyName = "",
    this.companyNamesList = const [],
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
    List<String>? companyNamesList,
    String? companyName,
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
      companyName: companyName ?? this.companyName,
      companyNamesList: companyNamesList ?? this.companyNamesList,
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
        companyName,
        companyNamesList,
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
