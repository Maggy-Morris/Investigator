part of 'all_employess_bloc.dart';

class AllEmployeesState extends Equatable {
  final List<Data> employeeNamesList;
  final String companyName;
  String personName;
  final String image;
  final String id;
  int pageIndex;
  int pageCount;
  int count;

  final String phoneNum;
  final String email;
  final String userId;
  final String profession;
  bool isSearching;
  final PlatformFile? imageFile;

  final Submission submission;

  AllEmployeesState({
      this.pageCount= 0,

    this.pageIndex = 0,
    this.count = 0,
    this.imageFile,
    this.id = '',
    this.phoneNum = "",
    this.email = "",
    this.profession = "",
    this.userId = "",
    this.isSearching = false,
    this.image = "",
    this.personName = "",
    this.companyName = "",
    this.employeeNamesList = const [],
    this.submission = Submission.initial,
   
  });

  AllEmployeesState copyWith({
    PlatformFile? imageFile,
    int? pageCount,

    int? pageIndex,
    int? count,
    String? id,
    String? phoneNum,
    String? email,
    String? profession,
    String? userId,
    bool? isSearching,
    String? image,
    List<Data>? employeeNamesList,
    String? companyName,
    String? personName,
    Submission? submission,
  
  }) {
    return AllEmployeesState(
      pageCount :pageCount ?? this.pageCount,
      count: count ?? this.count,
      imageFile: imageFile ?? this.imageFile,
      pageIndex: pageIndex ?? this.pageIndex,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      profession: profession ?? this.profession,
      phoneNum: phoneNum ?? this.phoneNum,

      ////////////////////////////////////
      isSearching: isSearching ?? this.isSearching,
      image: image ?? this.image,
      employeeNamesList: employeeNamesList ?? this.employeeNamesList,
      companyName: companyName ?? this.companyName,
      personName: personName ?? this.personName,
      submission: submission ?? this.submission,
      
    );
  }

  @override
  List<Object?> get props => [
    pageCount,
        id,
        isSearching,
        image,
        submission,
        imageFile,
        pageIndex,
        count,

        
        personName,
        companyName,
        employeeNamesList,
      ];
}
