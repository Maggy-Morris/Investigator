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

    on<UpdateEmployeeEvent>(_onUpdateEmployeeEvent);
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
        imageWidget: event.imageWidget, submission: Submission.loading));
    // Your logic here to fetch data and determine the imageWidget
  }

  /// Delete person data by Name
  _onDeletePersonByNameEvent(
      DeletePersonByNameEvent event, Emitter<SearchByImageState> emit) async {
    String companyNameRepo =
        AuthenticationRepository.instance.currentUser.companyName ?? "";
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
        ));
      } else if (value.data!.isEmpty) {
        emit(state.copyWith(
          submission: Submission.noDataFound,
        ));
      }

      // if (value != EmployeeModel()) {
      //   emit(const HomeState().copyWith(submission: Submission.success));
      // }

      else {
        emit(state.copyWith(submission: Submission.error));
      }
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
      );
      if (result.updated == true) {
        emit(state.copyWith(
          submission: Submission.success,

          // employeeNamesList:
        ));
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
          ),
        );
      } else {
        emit(state.copyWith(submission: Submission.noDataFound));
      }
    });
  }
}
