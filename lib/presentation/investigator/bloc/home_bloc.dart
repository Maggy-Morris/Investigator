import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/enum/enum.dart';
// import 'package:Investigator/core/models/add_camera_model.dart';
import 'package:Investigator/core/remote_provider/remote_provider.dart';

import '../../../core/models/add_company_model.dart';
import '../../../core/models/employee_model.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static HomeBloc get(context) => BlocProvider.of<HomeBloc>(context);
  HomeBloc() : super(HomeState()) {
    on<HomeEvent>(_onHomeEvent);
    // on<DataEvent>(_onDataEvent);

    /// change fields events
    on<AddCompanyEvent>(_onAddCompanyEvent);
    on<DeleteCompanyEvent>(_onDeleteCompanyEvent);

    // /// Add New Employee
   

    /// functionality Company get employees Data
    // on<GetPersonByNameEvent>(_onGetPersonByNameEvent);
    on<GetPersonByIdEvent>(_onGetPersonByIdEvent);
    on<AddCompanyName>(_onAddCompanyName);

    /// functionality Company delete employees Data
    on<SearchForEmployeeByVideoEvent>(_onSearchForEmployeeByVideoEvent);

    // on<DeletePersonByNameEvent>(_onDeletePersonByNameEvent);
    on<DeletePersonByIdEvent>(_onDeletePersonByIdEvent);
  }

  _onHomeEvent(HomeEvent event, Emitter<HomeState> emit) async {}

  // _onDataEvent(DataEvent event, Emitter<HomeState> emit) async {
  //   add(const GetCamerasNames());
  //   add(const GetSourceTypes());
  //   add(const GetModelsName());
  // }

  _onAddCompanyName(AddCompanyName event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        companyName: event.companyName, submission: Submission.editing));
  }

  /// Add Company Handle

  _onAddCompanyEvent(AddCompanyEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .addCompany(
      companyName: state.companyName,
    )
        .then((value) {
      // if (state.cameraSelectedModels.isNotEmpty) {
      //   add(const ApplyModelEvent());
      // }
      if (value != AddCompanyModel()) {
        emit(HomeState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }

  /// Delete Company Handle

  _onDeleteCompanyEvent(
      DeleteCompanyEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .deleteCompany(
      companyName: state.companyName,
    )
        .then((value) {
      // if (state.cameraSelectedModels.isNotEmpty) {
      //   add(const ApplyModelEvent());
      // }
      if (value != AddCompanyModel()) {
        emit(HomeState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }

////////////////////////////////////////////
 

  /// Add GetPersonByIdHandle
  _onGetPersonByIdEvent(
      GetPersonByIdEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .getDocumentById(
      companyName: state.companyName,
      personId: state.personId,
    )
        .then((value) {
      // if (state.companyName.isNotEmpty) {
      //   add(const ApplyModelEvent());
      // }
      if (value != EmployeeModel()) {
        emit(HomeState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }

 

  /// Delete person data by Id
  _onDeletePersonByIdEvent(
      DeletePersonByIdEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .deleteDocumentById(
      companyName: state.companyName,
      personId: state.personId,
    )
        .then((value) {
      if (value != EmployeeModel()) {
        emit(HomeState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }


/////////////////////////////////////////////
   
   ///search by video and 
   _onSearchForEmployeeByVideoEvent(
      SearchForEmployeeByVideoEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .searchForpersonByVideo(
      companyName: state.companyName,
      video: state.video,
      imageFile: state.imageFile,
      personName: state.personName,
      // image: state.image,
    )
        .then((value) {
      
      if (value != ()) {
        emit(HomeState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }
}
