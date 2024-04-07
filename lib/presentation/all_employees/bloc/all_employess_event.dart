part of 'all_employess_bloc.dart';

class AllEmployeesEvent extends Equatable {
  const AllEmployeesEvent();

  @override
  List<Object?> get props => [];
}

class ImageWidget extends AllEmployeesEvent {
  final Widget imageWidget;

  ImageWidget({required this.imageWidget});

  @override
  List<Object?> get props => [imageWidget];
}


class EditPageNumber extends AllEmployeesEvent {
  final int pageIndex;

  const EditPageNumber({required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}

class CameraMainDataEvent extends AllEmployeesEvent {
  const CameraMainDataEvent();

  @override
  List<Object?> get props => [];
}

class AddpersonName extends AllEmployeesEvent {
  final String personName;

  const AddpersonName({required this.personName});

  @override
  List<Object?> get props => [personName];
}

class AddphoneNum extends AllEmployeesEvent {
  final String phoneNum;

  const AddphoneNum({required this.phoneNum});

  @override
  List<Object?> get props => [phoneNum];
}

class Addemail extends AllEmployeesEvent {
  final String email;

  const Addemail({required this.email});

  @override
  List<Object?> get props => [email];
}

class AdduserId extends AllEmployeesEvent {
  final String userId;

  const AdduserId({required this.userId});

  @override
  List<Object?> get props => [userId];
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
class imageevent extends AllEmployeesEvent {
    final PlatformFile imageFile;

  const imageevent(
{required this.imageFile}

  );

  @override
  List<Object?> get props => [imageFile];
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
///////////////////////////////////////////

class UpdateEmployeeEvent extends AllEmployeesEvent {
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

////////////////////////////////////////////
class AddNewEmployee extends AllEmployeesEvent {
  final String companyName;
  final String personName;
  final String image;
  final String phoneNum;
  final String email;
  final String userId;

  // final String imageName;
  // PlatformFile? files;

  AddNewEmployee(
      {this.userId = '',
      this.personName = ' ',
      this.phoneNum = '',
      this.email = ' ',
      this.companyName = ' ',
      this.image = ''});

  @override
  List<Object?> get props => [
        companyName,
        personName,
        phoneNum,
        userId,
        email,
        image,
      ];
}

// get person data by name
class GetPersonByNameEvent extends AllEmployeesEvent {
  final String companyName;
  final String personName;
  const GetPersonByNameEvent(
      {required this.companyName, required this.personName});

  @override
  List<Object?> get props => [companyName, personName];
}

//////////////////////////////////

class CameraInitializeDate extends AllEmployeesEvent {
  const CameraInitializeDate();

  @override
  List<Object?> get props => [];
}
