import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'choose_your_company_event.dart';
part 'choose_your_company_state.dart';

class ChooseYourCompanyBloc extends Bloc<ChooseYourCompanyEvent, ChooseYourCompanyState> {
  static ChooseYourCompanyBloc get(context) =>
      BlocProvider.of<ChooseYourCompanyBloc>(context);

 
  ChooseYourCompanyBloc() : super(ChooseYourCompanyInitial()) {
    on<ChooseYourCompanyEvent>((event, emit) {
    });




  }
}
