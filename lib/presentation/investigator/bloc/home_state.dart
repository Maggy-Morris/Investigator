part of 'home_bloc.dart';

class HomeState extends Equatable {
  final String responseMessage;
  final bool load;
  final int timeDuration;

  final String pathProvided;

  final int pageIndex;
  final int pageCount;
  final List<Data> employeeNamesList;
  final List<String> companiesNamesList;
  final PlatformFile? video;

  final List<PlatformFile>? imagesListdata;

  final PlatformFile? imageFile;
  final Widget? imageWidget;
  final List<Widget> imageWidgetss;
  final List<String> snapShots;
  final String accuracy;
  final double sliderValue;
  final Submission submission;

  final String companyName;
  final String personName;
  final String personId;
  final List<String> data;

  const HomeState({
    this.imageWidgetss = const [],
    this.load = false,
    this.responseMessage = '',
    this.timeDuration = 0,
    this.pathProvided = "",
    this.pageCount = 0,
    this.pageIndex = 0,
    this.accuracy = '',
    this.sliderValue = 10,
    this.imageWidget,
    this.snapShots = const [],
    this.data = const [],
    this.imageFile,
    this.imagesListdata = const [],
    this.video,
    this.personName = "",
    this.personId = "",
    this.companyName = "",
    this.companiesNamesList = const [],
    this.employeeNamesList = const [],
    this.submission = Submission.initial,
  });

  HomeState copyWith({
    List<Widget>? imageWidgetss,
    bool? load,
    String? responseMessage,
    int? timeDuration,
    String? pathProvided,
    int? pageCount,
    int? pageIndex,
    String? accuracy,
    double? sliderValue,
    List<String>? snapShots,
    Widget? imageWidget,
    PlatformFile? video,
    PlatformFile? imageFile,
    List<PlatformFile>? imagesListdata,
    List<String>? companiesNamesList,
    List<Data>? employeeNamesList,
    String? companyName,
    String? personName,
    String? personId,
    Submission? submission,
    List<String>? data,
  }) {
    return HomeState(
      imageWidgetss: imageWidgetss ?? this.imageWidgetss,
      load: load ?? this.load,
      responseMessage: responseMessage ?? this.responseMessage,
      timeDuration: timeDuration ?? this.timeDuration,
      pathProvided: pathProvided ?? this.pathProvided,
      pageIndex: pageIndex ?? this.pageIndex,
      pageCount: pageCount ?? this.pageCount,
      accuracy: accuracy ?? this.accuracy,
      sliderValue: sliderValue ?? this.sliderValue,
      snapShots: snapShots ?? this.snapShots,
      imageWidget: imageWidget ?? this.imageWidget,
      data: data ?? this.data,
      video: video ?? this.video,
      imagesListdata: imagesListdata ?? this.imagesListdata,
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
        imageWidgetss,
        load,
        responseMessage,
        timeDuration,
        pathProvided,
        pageIndex,
        pageCount,
        accuracy,
    sliderValue,
        snapShots,
        imageWidget,
        data,
        video,
        imagesListdata,
        imageFile,
        personName,
        personId,
        companiesNamesList,
        companyName,
        employeeNamesList,
        submission,
      ];
}
