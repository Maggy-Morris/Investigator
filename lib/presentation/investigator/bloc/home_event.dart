part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class CompnyNameFromSP extends HomeEvent {
    final String companyName;

  const CompnyNameFromSP(
{required this.companyName}

  );

  @override
  List<Object?> get props => [companyName];
}



class SearchForEmployeeByVideoEvent extends HomeEvent {
  const SearchForEmployeeByVideoEvent();

  @override
  List<Object?> get props => [];
}


///

// class GetEmployeeNames extends HomeEvent {
//   final String companyName;

//   const GetEmployeeNames({required this.companyName});

//   @override
//   List<Object?> get props => [companyName];
// }

// /// Get Emoloyees Data event
// class GetEmployeeNamesEvent extends HomeEvent {
//   const GetEmployeeNamesEvent();

//   @override
//   List<Object?> get props => [];
// }

// class GetCompaniesNames extends HomeEvent {
//   const GetCompaniesNames();

//   @override
//   List<Object?> get props => [];
// }

// class GetCamerasNames extends HomeEvent {
//   const GetCamerasNames();

//   @override
//   List<Object?> get props => [];
// }

// class GetSourceTypes extends HomeEvent {
//   const GetSourceTypes();

//   @override
//   List<Object?> get props => [];
// }

// class GetModelsName extends HomeEvent {
//   const GetModelsName();

//   @override
//   List<Object?> get props => [];
// }

/// handle state events
///

class AddCompanyName extends HomeEvent {
  final String companyName;

  const AddCompanyName({required this.companyName});

  @override
  List<Object?> get props => [companyName];
}

// class AddCameraSource extends HomeEvent {
//   final String cameraSource;

//   const AddCameraSource({required this.cameraSource});

//   @override
//   List<Object?> get props => [cameraSource];
// }
class AddNewEmployeeEvent extends HomeEvent {
  const AddNewEmployeeEvent();

  @override
  List<Object?> get props => [];
}

class AddNewEmployee extends HomeEvent {
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

class AddCompanyEvent extends HomeEvent {
  const AddCompanyEvent();

  @override
  List<Object?> get props => [];
}

// Delete company event
class DeleteCompanyEvent extends HomeEvent {
  // final String companyName;

  const DeleteCompanyEvent(
      // this.companyName
      );

  @override
  List<Object?> get props => [];
}

// // get person data by name
// class GetPersonByNameEvent extends HomeEvent {
//   const GetPersonByNameEvent();

//   @override
//   List<Object?> get props => [];
// }

// class GetPersonByName extends HomeEvent {
//   final String companyName;
//   final String personName;
//   const GetPersonByName({required this.companyName, required this.personName});

//   @override
//   List<Object?> get props => [companyName, personName];
// }

// get person data by id
class GetPersonByIdEvent extends HomeEvent {
  final String companyName;
  final String personId;
  const GetPersonByIdEvent(this.companyName, this.personId);

  @override
  List<Object?> get props => [companyName, personId];
}

// // delete person data by name
// class DeletePersonByNameEvent extends HomeEvent {
//   final String companyName;
//   final String personName;

//   const DeletePersonByNameEvent(this.companyName, this.personName);

//   @override
//   List<Object?> get props => [companyName, personName];
// }

// delete person data by id
class DeletePersonByIdEvent extends HomeEvent {
  final String companyName;
  final String personId;
  const DeletePersonByIdEvent(this.companyName, this.personId);

  @override
  List<Object?> get props => [companyName, personId];
}

// /// add camera event
// class AddCameraEvent extends HomeEvent {
//   const AddCameraEvent();

//   @override
//   List<Object?> get props => [];
// }

/// apply model event
// class ApplyModelEvent extends HomeEvent {
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
