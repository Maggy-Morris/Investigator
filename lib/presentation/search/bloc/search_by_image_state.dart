part of 'search_by_image_bloc.dart';

class SearchByImageState extends Equatable {
  final String selectedOption;
  final String responseMessage;
  List<List<double>>? boxes;
  List<String>? result;
  List<String>? blacklis;

  final Widget? imageWidget;

  List<String>? textAccuracy;

  final String companyName;
  final String image;
  final Submission submission;

  final List<Dataa> employeeNamesList;
  String personName;
  final String id;

  final String phoneNum;
  final String email;
  final String userId;
  final String profession;
  bool isSearching;

  SearchByImageState({
    this.responseMessage = '',
    this.blacklis = const [],
    this.textAccuracy,
    this.selectedOption = "",
    this.isSearching = false,
    this.id = '',
    this.phoneNum = "",
    this.email = "",
    this.profession = "",
    this.userId = "",
    this.personName = "",
    this.employeeNamesList = const [],
    this.imageWidget,
    this.result,
    this.boxes,
    this.submission = Submission.initial,
    this.companyName = "",
    this.image = "",
  });

  SearchByImageState copyWith({
    List<String>? blacklis,
    List<String>? textAccuracy,
    String? selectedOption,
String? responseMessage,

    String? id,
    String? phoneNum,
    String? email,
    String? profession,
    String? userId,
    String? personName,
    bool? isSearching,
    List<Dataa>? employeeNamesList,
    List<List<double>>? boxes,
    Widget? imageWidget,
    List<String>? result,
    String? companyName,
    String? image,
    Submission? submission,
  }) {
    return SearchByImageState(
      responseMessage : responseMessage ?? this.responseMessage,
      blacklis: blacklis ?? this.blacklis,
      textAccuracy: textAccuracy ?? this.textAccuracy,
      selectedOption: selectedOption ?? this.selectedOption,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      profession: profession ?? this.profession,
      phoneNum: phoneNum ?? this.phoneNum,
      personName: personName ?? this.personName,

      ////////////////////////////////////
      isSearching: isSearching ?? this.isSearching,
      employeeNamesList: employeeNamesList ?? this.employeeNamesList,

      result: result ?? this.result,
      boxes: boxes ?? this.boxes,
      imageWidget: imageWidget ?? this.imageWidget,
      companyName: companyName ?? this.companyName,
      image: image ?? this.image,
      submission: submission ?? this.submission,
    );
  }

  @override
  List<Object?> get props => [
    responseMessage,
        blacklis,
        email,
        phoneNum,
        profession,
        userId,
        id,
        personName,
        textAccuracy,
        selectedOption,
        imageWidget,
        result,
        boxes,
        companyName,
        image,
        submission,
        isSearching,
        employeeNamesList,
      ];
}
