import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/enum/enum.dart';
// import 'package:Investigator/core/models/add_camera_model.dart';
import 'package:Investigator/core/remote_provider/remote_provider.dart';

import '../../../core/models/add_company_model.dart';
import '../../../core/models/employee_model.dart';

part 'group_search_event.dart';

part 'group_search_state.dart';

class GroupSearchBloc extends Bloc<GroupSearchEvent, GroupSearchState> {
  static GroupSearchBloc get(context) =>
      BlocProvider.of<GroupSearchBloc>(context);
  GroupSearchBloc() : super(GroupSearchState()) {
    on<GroupSearchEvent>(_onGroupSearchEvent);
    // on<DataEvent>(_onDataEvent);

    /// change fields events
    on<AddCompanyEvent>(_onAddCompanyEvent);
    on<DeleteCompanyEvent>(_onDeleteCompanyEvent);

    // /// Add New Employee

    on<reloadSnapShots>(_onreloadSnapShots);

    on<GetAccuracy>(_onGetAccuracy);

    on<imageevent>(_onimageevent);
    on<videoevent>(_onvideoevent);
    on<selectedFiltering>(_oselectedFiltering);

    /// functionality Company get employees Data
    // on<GetPersonByNameEvent>(_onGetPersonByNameEvent);
    on<GetPersonByIdEvent>(_onGetPersonByIdEvent);
    on<AddCompanyName>(_onAddCompanyName);

    /// functionality Company delete employees Data
    on<SearchForEmployeeByVideoEvent>(_onSearchForEmployeeByVideoEvent);
    on<ImageToSearchForEmployee>(_onImageToSearchForEmployee);

    // on<DeletePersonByNameEvent>(_onDeletePersonByNameEvent);
    on<DeletePersonByIdEvent>(_onDeletePersonByIdEvent);
  }

  _onGroupSearchEvent(
      GroupSearchEvent event, Emitter<GroupSearchState> emit) async {}

  // _onDataEvent(DataEvent event, Emitter<GroupSearchState> emit) async {
  //   add(const GetCamerasNames());
  //   add(const GetSourceTypes());
  //   add(const GetModelsName());
  // }

  _onImageToSearchForEmployee(
      ImageToSearchForEmployee event, Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(
        imageWidget: event.imageWidget, submission: Submission.loading));
    // Your logic here to fetch data and determine the imageWidget
  }

  _oselectedFiltering(
      selectedFiltering event, Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(
        filterCase: event.filterCase, submission: Submission.editing));
  }

  _onGetAccuracy(GetAccuracy event, Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(
        accuracy: event.accuracy, submission: Submission.editing));
  }

  _onreloadSnapShots(
      reloadSnapShots event, Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(
        snapShots: event.snapyy, submission: Submission.editing));
  }

  _onAddCompanyName(
      AddCompanyName event, Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(
        companyName: event.companyName, submission: Submission.editing));
  }

  _onimageevent(imageevent event, Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(
        imageFile: event.imageFile, submission: Submission.editing));
  }

  _onvideoevent(videoevent event, Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(video: event.video, submission: Submission.editing));
  }

  /// Add Company Handle

  _onAddCompanyEvent(
      AddCompanyEvent event, Emitter<GroupSearchState> emit) async {
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
        emit(GroupSearchState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }

  /// Delete Company Handle

  _onDeleteCompanyEvent(
      DeleteCompanyEvent event, Emitter<GroupSearchState> emit) async {
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
        emit(GroupSearchState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }

////////////////////////////////////////////

  /// Add GetPersonByIdHandle
  _onGetPersonByIdEvent(
      GetPersonByIdEvent event, Emitter<GroupSearchState> emit) async {
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
        emit(GroupSearchState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }

  /// Delete person data by Id
  _onDeletePersonByIdEvent(
      DeletePersonByIdEvent event, Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .deleteDocumentById(
      companyName: state.companyName,
      personId: state.personId,
    )
        .then((value) {
      if (value != EmployeeModel()) {
        emit(GroupSearchState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }

/////////////////////////////////////////////

  ///search by video and
  _onSearchForEmployeeByVideoEvent(SearchForEmployeeByVideoEvent event,
      Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .searchForpersonByVideo(
      similarityScore: state.accuracy,
      video: state.video,
      image: state.imageFile,
      // personName: state.personName,
      // image: state.image,
    )
        .then((value) {
      if (value.found == true) {
        emit(state.copyWith(
          submission: Submission.success,
          data: value.data,
          snapShots: value.snapshot_list,
        ));
      } else if (value.found == false) {
        emit(state.copyWith(
          data: [],
          snapShots: [],
          submission: Submission.noDataFound,
        ));
      }
    });
  }
}
