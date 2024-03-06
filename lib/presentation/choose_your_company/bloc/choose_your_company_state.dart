part of 'choose_your_company_bloc.dart';

sealed class ChooseYourCompanyState extends Equatable {
  const ChooseYourCompanyState();
  
  @override
  List<Object> get props => [];
}

final class ChooseYourCompanyInitial extends ChooseYourCompanyState {}
