part of 'group_search_bloc.dart';

class GroupSearchEvent extends Equatable {
  const GroupSearchEvent();

  @override
  List<Object?> get props => [];
}


class EditPageCount extends GroupSearchEvent {
  final int pageCount;

  const EditPageCount({required this.pageCount});

  @override
  List<Object> get props => [pageCount];
}
class EditPageNumber extends GroupSearchEvent {
  final int pageIndex;

  const EditPageNumber({required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}

// class GetPaginatedFramesEvent extends GroupSearchEvent {
//   const GetPaginatedFramesEvent();

//   @override
//   List<Object> get props => [];
// }

class selectedFiltering extends GroupSearchEvent {
  final String filterCase;

  const selectedFiltering({required this.filterCase});

  @override
  List<Object?> get props => [filterCase];
}

class AddpersonName extends GroupSearchEvent {
  final String personName;

  const AddpersonName({required this.personName});

  @override
  List<Object?> get props => [personName];
}

class AddphoneNum extends GroupSearchEvent {
  final String phoneNum;

  const AddphoneNum({required this.phoneNum});

  @override
  List<Object?> get props => [phoneNum];
}

class Addemail extends GroupSearchEvent {
  final String email;

  const Addemail({required this.email});

  @override
  List<Object?> get props => [email];
}

class AdduserId extends GroupSearchEvent {
  final String userId;

  const AdduserId({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdateEmployeeEvent extends GroupSearchEvent {
  final String companyName;
  final String personName;
  final String image;
  final String phoneNum;
  final String email;
  final String userId;
  final String id;

  const UpdateEmployeeEvent(
      {this.id = '',
      this.userId = '',
      this.personName = ' ',
      this.phoneNum = '',
      this.email = ' ',
      this.companyName = ' ',
      this.image = ''});

  @override
  List<Object?> get props => [
        id,
        companyName,
        personName,
        phoneNum,
        userId,
        email,
        image,
      ];
}

class ImageToSearchForEmployee extends GroupSearchEvent {
  final Widget imageWidget;

  ImageToSearchForEmployee({required this.imageWidget});

  @override
  List<Object?> get props => [imageWidget];
}

class CompnyNameFromSP extends GroupSearchEvent {
  final String companyName;

  const CompnyNameFromSP({required this.companyName});

  @override
  List<Object?> get props => [companyName];
}

class DeletePersonByNameEvent extends GroupSearchEvent {
  final String companyName;
  final String personName;

  const DeletePersonByNameEvent(this.companyName, this.personName);

  @override
  List<Object?> get props => [companyName, personName];
}

class reloadTargetsData extends GroupSearchEvent {
  final List<Dataaa> Employyyy;

  const reloadTargetsData({required this.Employyyy});

  @override
  List<Object?> get props => [Employyyy];
}

class reloadSnapShots extends GroupSearchEvent {
  final List<String> snapyy;

  const reloadSnapShots({required this.snapyy});

  @override
  List<Object?> get props => [snapyy];
}



class reloadPath extends GroupSearchEvent {
  final String path_provided;

  const reloadPath({required this.path_provided});

  @override
  List<Object?> get props => [path_provided];
}

class GetAccuracy extends GroupSearchEvent {
  final String accuracy;

  const GetAccuracy({required this.accuracy});

  @override
  List<Object?> get props => [accuracy];
}

class getPersonName extends GroupSearchEvent {
  final String personName;

  const getPersonName({required this.personName});

  @override
  List<Object?> get props => [personName];
}

class imageevent extends GroupSearchEvent {
  final PlatformFile imageFile;

  const imageevent({required this.imageFile});

  @override
  List<Object?> get props => [imageFile];
}

class videoevent extends GroupSearchEvent {
  final PlatformFile video;

  const videoevent({required this.video});

  @override
  List<Object?> get props => [video];
}

class SearchForEmployeeByVideoEvent extends GroupSearchEvent {
  const SearchForEmployeeByVideoEvent();

  @override
  List<Object?> get props => [];
}

class RadioButtonChanged extends GroupSearchEvent {
  final String selectedOption;
  final bool? showTextField;

  const RadioButtonChanged({required this.selectedOption, this.showTextField});
}

/////////////////////////////////////
class checkBox extends GroupSearchEvent {
  final List<String> room_NMs;

  const checkBox({required this.room_NMs});

  @override
  List<Object?> get props => [room_NMs];
}

///

// class GetEmployeeNames extends GroupSearchEvent {
//   final String companyName;

//   const GetEmployeeNames({required this.companyName});

//   @override
//   List<Object?> get props => [companyName];
// }

// /// Get Emoloyees Data event
// class GetEmployeeNamesEvent extends GroupSearchEvent {
//   const GetEmployeeNamesEvent();

//   @override
//   List<Object?> get props => [];
// }

// class GetCompaniesNames extends GroupSearchEvent {
//   const GetCompaniesNames();

//   @override
//   List<Object?> get props => [];
// }

// class GetCamerasNames extends GroupSearchEvent {
//   const GetCamerasNames();

//   @override
//   List<Object?> get props => [];
// }

// class GetSourceTypes extends GroupSearchEvent {
//   const GetSourceTypes();

//   @override
//   List<Object?> get props => [];
// }

// class GetModelsName extends GroupSearchEvent {
//   const GetModelsName();

//   @override
//   List<Object?> get props => [];
// }

/// handle state events
///

class AddCompanyName extends GroupSearchEvent {
  final String companyName;

  const AddCompanyName({required this.companyName});

  @override
  List<Object?> get props => [companyName];
}

// class AddCameraSource extends GroupSearchEvent {
//   final String cameraSource;

//   const AddCameraSource({required this.cameraSource});

//   @override
//   List<Object?> get props => [cameraSource];
// }
class AddNewEmployeeEvent extends GroupSearchEvent {
  const AddNewEmployeeEvent();

  @override
  List<Object?> get props => [];
}

class AddNewEmployee extends GroupSearchEvent {
  final String companyName;
  final String personName;
  final String image;
  // final String imageName;
  // PlatformFile? files;

  AddNewEmployee(
      {
      // this.files,
      // this.imageName,

      required this.personName,
      required this.companyName,
      required this.image});

  @override
  List<Object?> get props => [
        companyName, personName,
        // files,
        image,
        // imageName
      ];
}

// Add company event

class AddCompanyEvent extends GroupSearchEvent {
  const AddCompanyEvent();

  @override
  List<Object?> get props => [];
}

// Delete company event
class DeleteCompanyEvent extends GroupSearchEvent {
  // final String companyName;

  const DeleteCompanyEvent(
      // this.companyName
      );

  @override
  List<Object?> get props => [];
}

// // get person data by name
// class GetPersonByNameEvent extends GroupSearchEvent {
//   const GetPersonByNameEvent();

//   @override
//   List<Object?> get props => [];
// }

// class GetPersonByName extends GroupSearchEvent {
//   final String companyName;
//   final String personName;
//   const GetPersonByName({required this.companyName, required this.personName});

//   @override
//   List<Object?> get props => [companyName, personName];
// }

// get person data by id
class GetPersonByIdEvent extends GroupSearchEvent {
  final String companyName;
  final String personId;
  const GetPersonByIdEvent(this.companyName, this.personId);

  @override
  List<Object?> get props => [companyName, personId];
}

// // delete person data by name
// class DeletePersonByNameEvent extends GroupSearchEvent {
//   final String companyName;
//   final String personName;

//   const DeletePersonByNameEvent(this.companyName, this.personName);

//   @override
//   List<Object?> get props => [companyName, personName];
// }

// delete person data by id
class DeletePersonByIdEvent extends GroupSearchEvent {
  final String companyName;
  final String personId;
  const DeletePersonByIdEvent(this.companyName, this.personId);

  @override
  List<Object?> get props => [companyName, personId];
}

// /// add camera event
// class AddCameraEvent extends GroupSearchEvent {
//   const AddCameraEvent();

//   @override
//   List<Object?> get props => [];
// }

/// apply model event
// class ApplyModelEvent extends GroupSearchEvent {
//   // final String cameraName;
//   // final List<String> modelName;

//   const ApplyModelEvent(
//       //     {
//       //   required this.modelName,
//       //   required this.cameraName,
//       // }
//       );

//   @override
//   List<Object?> get props => [
//         // cameraName,
//         // modelName,
//       ];
// }
