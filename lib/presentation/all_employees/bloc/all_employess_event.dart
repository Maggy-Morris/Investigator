part of 'all_employess_bloc.dart';

class AllEmployeesEvent extends Equatable {
  const AllEmployeesEvent();

  @override
  List<Object?> get props => [];
}

class CameraMainDataEvent extends AllEmployeesEvent {
  const CameraMainDataEvent();

  @override
  List<Object?> get props => [];
}

class GetEmployeeNames extends AllEmployeesEvent {
  final String companyName;

  const GetEmployeeNames({required this.companyName});

  @override
  List<Object?> get props => [companyName];
}

/// Get Emoloyees Data event
class GetEmployeeNamesEvent extends AllEmployeesEvent {
  const GetEmployeeNamesEvent();

  @override
  List<Object?> get props => [];
}

// delete person data by name
class DeletePersonByNameEvent extends AllEmployeesEvent {
  final String companyName;
  final String personName;

  const DeletePersonByNameEvent(this.companyName, this.personName);

  @override
  List<Object?> get props => [companyName, personName];
}

////////////////////////////////////AddNewEmployeeEvent
class AddNewEmployeeEvent extends AllEmployeesEvent {
  const AddNewEmployeeEvent();

  @override
  List<Object?> get props => [];
}

class AddNewEmployee extends AllEmployeesEvent {
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



// get person data by name
class GetPersonByNameEvent extends AllEmployeesEvent {
  const GetPersonByNameEvent();

  @override
  List<Object?> get props => [];
}

class GetPersonByName extends AllEmployeesEvent {
  final String companyName;
  final String personName;
  const GetPersonByName({required this.companyName, required this.personName});

  @override
  List<Object?> get props => [companyName, personName];
}
//////////////////////////////////

class CameraInitializeDate extends AllEmployeesEvent {
  const CameraInitializeDate();

  @override
  List<Object?> get props => [];
}

class CameraDetailsEvent extends AllEmployeesEvent {
  final String cameraName;

  const CameraDetailsEvent({required this.cameraName});

  @override
  List<Object?> get props => [cameraName];
}

class GetModelsChartsData extends AllEmployeesEvent {
  final List<String> modelsList;
  final String cameraName;

  const GetModelsChartsData(
      {required this.modelsList, required this.cameraName});

  @override
  List<Object?> get props => [modelsList, cameraName];
}

class CameraAddDay extends AllEmployeesEvent {
  final String selectedDay;

  const CameraAddDay({required this.selectedDay});

  @override
  List<Object?> get props => [selectedDay];
}

class CameraAddMonth extends AllEmployeesEvent {
  final String selectedMonth;

  const CameraAddMonth({required this.selectedMonth});

  @override
  List<Object?> get props => [selectedMonth];
}

class CameraAddYear extends AllEmployeesEvent {
  final String selectedYear;

  const CameraAddYear({required this.selectedYear});

  @override
  List<Object?> get props => [selectedYear];
}
