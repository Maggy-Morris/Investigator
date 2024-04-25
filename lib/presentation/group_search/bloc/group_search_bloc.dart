import 'package:Investigator/authentication/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/enum/enum.dart';
// import 'package:Investigator/core/models/add_camera_model.dart';
import 'package:Investigator/core/remote_provider/remote_provider.dart';

import '../../../core/models/add_company_model.dart';
import '../../../core/models/employee_model.dart';
import '../../../core/models/search_by_image_model.dart';
import '../../../core/models/search_by_video_in_group_search.dart';

part 'group_search_event.dart';

part 'group_search_state.dart';

class GroupSearchBloc extends Bloc<GroupSearchEvent, GroupSearchState> {
  String companyNameRepo =
      AuthenticationRepository.instance.currentUser.companyName?.first ?? "";
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

    on<reloadTargetsData>(_onreloadTargetsData);

    on<GetAccuracy>(_onGetAccuracy);
    on<RadioButtonChanged>(_onRadioButtonChanged);
    on<checkBox>(_oncheckBox);

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

    /// Add New Employee

    on<AddpersonName>(_onAddpersonName);
    on<AddphoneNum>(_onAddphoneNum);
    on<Addemail>(_onAddemail);
    on<AdduserId>(_onAdduserId);
    on<DeletePersonByNameEvent>(_onDeletePersonByNameEvent);
    on<DeletePersonByIdEvent>(_onDeletePersonByIdEvent);

    on<UpdateEmployeeEvent>(_onUpdateEmployeeEvent);
  }

  _onGroupSearchEvent(
      GroupSearchEvent event, Emitter<GroupSearchState> emit) async {}

  // _onDataEvent(DataEvent event, Emitter<GroupSearchState> emit) async {
  //   add(const GetCamerasNames());
  //   add(const GetSourceTypes());
  //   add(const GetModelsName());
  // }

  _onUpdateEmployeeEvent(
      UpdateEmployeeEvent event, Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    try {
      final result = await RemoteProvider().UpdateEmployeeData(
          companyName: event.companyName,
          personName: state.personName,
          phoneNum: state.phoneNum,
          email: state.email,
          userId: state.userId,
          id: event.id,
          blackListed: "",
          roomNamesChoosen: []);
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

  _onreloadTargetsData(
      reloadTargetsData event, Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(
        employeeNamesList: event.Employyyy, submission: Submission.editing));
  }

  _onreloadSnapShots(
      reloadSnapShots event, Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(
        snapShots: event.snapyy, submission: Submission.editing));
  }

  _onAddpersonName(AddpersonName event, Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(
      personName: event.personName,
      submission: Submission.hasData,
    ));
  }

  _onAddphoneNum(AddphoneNum event, Emitter<GroupSearchState> emit) async {
    // .getAllEmployeeNames(companyName: state.companyName)
    // .then((value) {
    emit(state.copyWith(
        phoneNum: event.phoneNum, submission: Submission.hasData));
  }

  _onAddemail(Addemail event, Emitter<GroupSearchState> emit) async {
    // .getAllEmployeeNames(companyName: state.companyName)
    // .then((value) {
    emit(state.copyWith(email: event.email, submission: Submission.hasData));
    // });
  }

  _onAdduserId(AdduserId event, Emitter<GroupSearchState> emit) async {
    // .getAllEmployeeNames(companyName: state.companyName)
    // .then((value) {
    emit(state.copyWith(userId: event.userId, submission: Submission.hasData));
    // });
  }
  ///////////////////////////////////////////////////

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

  /// Delete person data by Name
  _onDeletePersonByNameEvent(
      DeletePersonByNameEvent event, Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .deleteDocumentByName(
      companyName: companyNameRepo,
      personName: event.personName,
    )
        .then((value) {
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

      else {
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
        .searchForpersonByVideoGroupSearch(
      similarityScore: state.accuracy,
      video: state.video,
      filterCase: state.filterCase,
      companyName:
          AuthenticationRepository.instance.currentUser.companyName?.first ??
              "",
    )
        .then((value) {
      if (value.found == true) {
        emit(state.copyWith(
          submission: Submission.success,
          data: value.data,
          timestamps:value.timestamps,
          snapShots: value.snapshot_list,
          employeeNamesList: value.dataCards,
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

  _oncheckBox(checkBox event, Emitter<GroupSearchState> emit) async {
    emit(state.copyWith(
        roomNAMS: event.room_NMs, submission: Submission.editing));
  }

  //RadioButton
  _onRadioButtonChanged(
      RadioButtonChanged event, Emitter<GroupSearchState> emit) async {
    emit(
      state.copyWith(
        selectedOption: event.selectedOption,
        submission: Submission.loading,
        showTextField: event.showTextField,
      ),
    );
  }
}
