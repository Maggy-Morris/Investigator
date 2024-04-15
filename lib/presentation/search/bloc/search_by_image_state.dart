part of 'search_by_image_bloc.dart';

class SearchByImageState extends Equatable {
  final String selectedOption;

  List<List<double>>? boxes;
  List<String>? result;
  final Widget? imageWidget;

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
    this.selectedOption = "",
    this.id = '',
    this.phoneNum = "",
    this.email = "",
    this.profession = "",
    this.userId = "",
    this.isSearching = false,
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
    String? selectedOption,
    String? id,
    String? phoneNum,
    String? email,
    String? profession,
    String? userId,
    bool? isSearching,
    List<Dataa>? employeeNamesList,
    String? personName,
    List<List<double>>? boxes,
    Widget? imageWidget,
    List<String>? result,
    String? companyName,
    String? image,
    Submission? submission,
  }) {
    return SearchByImageState(
      selectedOption : selectedOption ?? this.selectedOption,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      profession: profession ?? this.profession,
      phoneNum: phoneNum ?? this.phoneNum,

      ////////////////////////////////////
      isSearching: isSearching ?? this.isSearching,
      employeeNamesList: employeeNamesList ?? this.employeeNamesList,
      personName: personName ?? this.personName,

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
    selectedOption,
        imageWidget,
        result,
        boxes,
        companyName,
        image,
        submission,
        id,
        isSearching,
        personName,
        employeeNamesList,
      ];
}
