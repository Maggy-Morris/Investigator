part of 'search_by_image_bloc.dart';

class SearchByImageEvent extends Equatable {
  const SearchByImageEvent();

  @override
  List<Object?> get props => [];
}

class SearchForEmployeeEvent extends SearchByImageEvent {
  const SearchForEmployeeEvent();

  @override
  List<Object?> get props => [];
}


class ImageToSearchForEmployee extends SearchByImageEvent {
  final Widget imageWidget;

  ImageToSearchForEmployee({required this.imageWidget});

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
