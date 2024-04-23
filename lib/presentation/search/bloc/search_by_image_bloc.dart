import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/authentication_repository.dart';
import '../../../core/enum/enum.dart';
import '../../../core/models/search_by_image_model.dart';
import '../../../core/remote_provider/remote_provider.dart';

part 'search_by_image_event.dart';
part 'search_by_image_state.dart';

class SearchByImageBloc extends Bloc<SearchByImageEvent, SearchByImageState> {
  static SearchByImageBloc get(context) =>
      BlocProvider.of<SearchByImageBloc>(context);

  SearchByImageBloc() : super(SearchByImageState()) {
    on<SearchByImageEvent>((event, emit) {});

    on<SearchForEmployee>(_onSearchForEmployee);
    on<SearchForEmployeeEvent>(_onSearchForEmployeeEvent);
    on<ImageToSearchForEmployee>(_onImageToSearchForEmployee);

    /// Delete
    on<DeletePersonByNameEvent>(_onDeletePersonByNameEvent);

    /// Add New Employee

    on<AddpersonName>(_onAddpersonName);
    on<AddphoneNum>(_onAddphoneNum);
    on<Addemail>(_onAddemail);
    on<AdduserId>(_onAdduserId);

//edit
    on<RadioButtonChanged>(_onRadioButtonChanged);
    on<reloadEmployeeData>(_onreloadEmployeeData);
    on<checkBox>(_oncheckBox);

    on<UpdateEmployeeEvent>(_onUpdateEmployeeEvent);
  }

  _onreloadEmployeeData(
      reloadEmployeeData event, Emitter<SearchByImageState> emit) async {
    emit(state.copyWith(
      employeeNamesList: event.employeeData,
      result: event.resultData,
      textAccuracy: event.textAccuracyData,
      boxes: event.boxesData,
      blacklis: event.blacklisData,
      submission: Submission.hasData,
    ));
  }

  _oncheckBox(checkBox event, Emitter<SearchByImageState> emit) async {
    emit(state.copyWith(
        roomNAMS: event.room_NMs, submission: Submission.editing));
  }

  _onAddpersonName(
      AddpersonName event, Emitter<SearchByImageState> emit) async {
    emit(state.copyWith(
      personName: event.personName,
      submission: Submission.hasData,
    ));
  }

  _onAddphoneNum(AddphoneNum event, Emitter<SearchByImageState> emit) async {
    // .getAllEmployeeNames(companyName: state.companyName)
    // .then((value) {
    emit(state.copyWith(
        phoneNum: event.phoneNum, submission: Submission.hasData));
  }

  _onAddemail(Addemail event, Emitter<SearchByImageState> emit) async {
    // .getAllEmployeeNames(companyName: state.companyName)
    // .then((value) {
    emit(state.copyWith(email: event.email, submission: Submission.hasData));
    // });
  }

  _onAdduserId(AdduserId event, Emitter<SearchByImageState> emit) async {
    // .getAllEmployeeNames(companyName: state.companyName)
    // .then((value) {
    emit(state.copyWith(userId: event.userId, submission: Submission.hasData));
    // });
  }
  ///////////////////////////////////////////////////

  _onSearchForEmployee(
      SearchForEmployee event, Emitter<SearchByImageState> emit) async {
    // .getAllEmployeeNames(companyName: state.companyName)
    // .then((value) {
    emit(state.copyWith(
        companyName: event.companyName,
        image: event.image,
        submission: Submission.hasData));
    // });
  }

  _onImageToSearchForEmployee(
      ImageToSearchForEmployee event, Emitter<SearchByImageState> emit) async {
    emit(state.copyWith(
        imageWidget: event.imageWidget, submission: Submission.hasData));
    // Your logic here to fetch data and determine the imageWidget
  }

  /// Delete person data by Name
  _onDeletePersonByNameEvent(
      DeletePersonByNameEvent event, Emitter<SearchByImageState> emit) async {
    String companyNameRepo =
        AuthenticationRepository.instance.currentUser.companyName?.first ?? "";
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .deleteDocumentByName(
      companyName: companyNameRepo,
      personName: event.personName,
    )
        .then((value) {
      /// this to update the state once i deleted a person
      if (value.data != "No documents found for deletion.") {
        // Remove the deleted employee from the state
        final updatedList = state.employeeNamesList
            .where((employee) => employee.name != event.personName)
            .toList();
        emit(state.copyWith(
            submission: Submission.success,
            employeeNamesList: updatedList,
            responseMessage: value.data));
      } else if (value.data == "No documents found for deletion.") {
        emit(state.copyWith(
            submission: Submission.error, responseMessage: value.data));
      } else if (value.data?.isEmpty == true) {
        emit(state.copyWith(
          submission: Submission.noDataFound,
        ));
      }

      // if (value != EmployeeModel()) {
      //   emit(const HomeState().copyWith(submission: Submission.success));
      // }
    });
  }

  _onUpdateEmployeeEvent(
      UpdateEmployeeEvent event, Emitter<SearchByImageState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    try {
      final result = await RemoteProvider().UpdateEmployeeData(
        companyName: event.companyName,
        personName: state.personName,
        phoneNum: state.phoneNum,
        email: state.email,
        userId: state.userId,
        id: event.id,
        blackListed: state.selectedOption,
        roomNamesChoosen: state.roomNAMS,
      );
      if (result.updated == true) {
        emit(
          state.copyWith(
            submission: Submission.success,

            // employeeNamesList:
          ),
        );
        // add(const GetEmployeeNamesEvent());
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(submission: Submission.error));
    }
  }

  _onSearchForEmployeeEvent(
      SearchForEmployeeEvent event, Emitter<SearchByImageState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .searchForpersonByImage(
      username: AuthenticationRepository.instance.currentUser.username ?? '',
      companyName: state.companyName,
      image: state.image,
    )
        .then((value) {
      if (value.targeted == true) {
        emit(
          SearchByImageState().copyWith(
            submission: Submission.success,
            boxes: value.boxes,
            result: value.result,
            employeeNamesList: value.data,
            textAccuracy: value.textAccuracy,
            blacklis: value.blacklis,
          ),
        );
      } else {
        emit(state.copyWith(submission: Submission.noDataFound));
      }
    });
  }

  //RadioButton
  _onRadioButtonChanged(
      RadioButtonChanged event, Emitter<SearchByImageState> emit) async {
    emit(
      state.copyWith(
        selectedOption: event.selectedOption,
        submission: Submission.loading,
        showTextField: event.showTextField,
      ),
    );
  }
}
