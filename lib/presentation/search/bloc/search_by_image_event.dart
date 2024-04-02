part of 'search_by_image_bloc.dart';

class SearchByImageEvent extends Equatable {
  const SearchByImageEvent();

  @override
  List<Object?> get props => [];
}

class AddpersonName extends SearchByImageEvent {
  final String personName;

  const AddpersonName({required this.personName});

  @override
  List<Object?> get props => [personName];
}

class AddphoneNum extends SearchByImageEvent {
  final String phoneNum;

  const AddphoneNum({required this.phoneNum});

  @override
  List<Object?> get props => [phoneNum];
}

class Addemail extends SearchByImageEvent {
  final String email;

  const Addemail({required this.email});

  @override
  List<Object?> get props => [email];
}

class AdduserId extends SearchByImageEvent {
  final String userId;

  const AdduserId({required this.userId});

  @override
  List<Object?> get props => [userId];
}



class DeletePersonByNameEvent extends SearchByImageEvent {
  final String companyName;
  final String personName;

  const DeletePersonByNameEvent(this.companyName, this.personName);

  @override
  List<Object?> get props => [companyName, personName];
}



class UpdateEmployeeEvent extends SearchByImageEvent {
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

class SearchForEmployeeEvent extends SearchByImageEvent {
  const SearchForEmployeeEvent();

  @override
  List<Object?> get props => [];
}


class ImageToSearchForEmployee extends SearchByImageEvent {
  final Widget imageWidget;

  const ImageToSearchForEmployee({required this.imageWidget});

  @override
  List<Object?> get props => [imageWidget];
}


class SearchForEmployee extends SearchByImageEvent {
  final String companyName;
  final String image;
  const SearchForEmployee({required this.companyName, required this.image});

  @override
  List<Object?> get props => [companyName];
}
