import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
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

    /// Add New Employee
    on<AddNewEmployee>(_onAddNewEmployee);
    on<AddNewEmployeeEvent>(_onAddNewEmployeeEvent);

    /// get static list

    on<GetPersonByName>(_onGetPersonByName);

    on<GetEmployeeNames>(_onGetEmployeeNames);
    on<GetEmployeeNamesEvent>(_onGetEmployeeNamesEvent);

    // on<GetCompaniesNames>(_onGetCompaniesNames);

    /// functionality Company get employees Data
    on<GetPersonByNameEvent>(_onGetPersonByNameEvent);
    on<GetPersonByIdEvent>(_onGetPersonByIdEvent);
    on<AddCompanyName>(_onAddCompanyName);

    /// functionality Company delete employees Data

    on<DeletePersonByNameEvent>(_onDeletePersonByNameEvent);
    on<DeletePersonByIdEvent>(_onDeletePersonByIdEvent);

    /// functionality cameras

    // on<AddCameraEvent>(_onAddCameraEvent);
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

  /// New Employees Added
  _onAddNewEmployee(AddNewEmployee event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        companyName: event.companyName,
        personName: event.personName,
        // files: event.files,
        image: event.image,
        submission: Submission.editing));
  }

  _onAddNewEmployeeEvent(
      AddNewEmployeeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .addNewPersonToACompany(
      companyName: state.companyName,
      personName: state.personName,
      // image: state.files,
      image:state.image,
    )
        .then((value) {
      // if (state.cameraSelectedModels.isNotEmpty) {
      //   add(const ApplyModelEvent());
      // }
      if (value != AddCompanyModel()) {
        emit(const HomeState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }

  /// Get Company Employees Handle

  _onGetEmployeeNames(GetEmployeeNames event, Emitter<HomeState> emit) async {
    // await RemoteProvider()
    //     .getAllEmployeeNames(companyName: state.companyName)
    //     .then((value) {
    emit(state.copyWith(
        companyName: event.companyName, submission: Submission.hasData));
    // });
  }

  _onGetEmployeeNamesEvent(
      GetEmployeeNamesEvent event, Emitter<HomeState> emit) async {
    // Check if the data is already loaded
    // if (state.submission == Submission.success) {
    //   return;
    // }

    emit(state.copyWith(submission: Submission.loading));

    try {
      final employeeModel = await RemoteProvider().getAllEmployeeNames(
        companyName: state.companyName,
      );

      if (employeeModel.isNotEmpty) {
        emit(state.copyWith(
          submission: Submission.success,
          employeeNamesList: employeeModel,
        ));
      } else {
        emit(state.copyWith(
          submission: Submission.noDataFound,
          employeeNamesList: [],
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        submission: Submission.error,
        employeeNamesList: [],
      ));
    }
  }
  // _onGetEmployeeNamesEvent(
  //     GetEmployeeNamesEvent event, Emitter<HomeState> emit) async {
  //   emit(state.copyWith(submission: Submission.loading));

  //   try {
  //     final employeeModel = await RemoteProvider().getAllEmployeeNames(
  //       companyName: state.companyName,
  //     );

  //     if (employeeModel.isNotEmpty) {
  //       // final List<EmployeeModel> employeeList =
  //       //     List<EmployeeModel>.from(employeeModel.data!);

  //       emit(state.copyWith(
  //         submission: Submission.success,
  //         employeeNamesList: employeeModel,
  //       ));
  //     } else {
  //       emit(state.copyWith(
  //         submission: Submission.noDataFound,
  //         employeeNamesList: [],
  //       ));
  //     }
  //   } catch (e) {
  //     emit(state.copyWith(
  //       submission: Submission.error,
  //       employeeNamesList: [],
  //     ));
  //   }
  // }

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
        emit(const HomeState().copyWith(submission: Submission.success));
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
        emit(const HomeState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }

////////////////////////////////////////////
  ///
  _onGetPersonByName(GetPersonByName event, Emitter<HomeState> emit) async {
    // await RemoteProvider()
    //     .getPersonByName(
    //         companyName: state.companyName, personName: state.personName)
    //     .then((value) {
    emit(state.copyWith(
        companyName: event.companyName, submission: Submission.hasData));
    // });
  }

//////////////////////////////////////////
  /// Add GetPersonByName Handle
  _onGetPersonByNameEvent(
      GetPersonByNameEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .getPersonByName(
      companyName: state.companyName,
      personName: state.personName,
    )
        .then((value) {
      // if (state.companyName.isNotEmpty) {
      //   add(const ApplyModelEvent());
      // }
      if (value != EmployeeModel()) {
        // final updatedList = state.employeeNamesList
        //     .where((employee) => employee.name != event.personName)
        //     .toList();
        // emit(const HomeState().copyWith(
        //   submission: Submission.success,
        //   employeeNamesList: updatedList,
        // ));
      } else {
        emit(state.copyWith(
          submission: Submission.error,
        ));
      }
    });
  }

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
        emit(const HomeState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }

  /// Delete person data by Name
  _onDeletePersonByNameEvent(
      DeletePersonByNameEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .deleteDocumentByName(
      companyName: state.companyName,
      personName: state.personName,
    )
        .then((value) {
      /// this to update the state once i deleted a person
      if (value != EmployeeModel()) {
        // Remove the deleted employee from the state
        final updatedList = state.employeeNamesList
            .where((employee) => employee.name != event.personName)
            .toList();
        emit(state.copyWith(
          submission: Submission.success,
          employeeNamesList: updatedList,
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
        emit(const HomeState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }
  // _onAddCameraName(AddCameraName event, Emitter<HomeState> emit) async {
  //   emit(state.copyWith(
  //       cameraName: event.cameraName, submission: Submission.editing));
  // }

  // _onAddCameraSource(AddCameraSource event, Emitter<HomeState> emit) async {
  //   emit(state.copyWith(
  //       cameraSource: event.cameraSource, submission: Submission.editing));
  // }

  // _onAddCameraSourceType(
  //     AddCameraSourceType event, Emitter<HomeState> emit) async {
  //   emit(state.copyWith(
  //       cameraSourceType: event.cameraSourceType,
  //       submission: Submission.editing));
  // }

  // _onAddCameraSourceModels(
  //     AddCameraSourceModels event, Emitter<HomeState> emit) async {
  //   emit(state.copyWith(
  //       cameraSelectedModels: event.cameraSelectedModels,
  //       submission: Submission.editing));
  // }

  /// get static lists

  // _onGetCamerasNames(GetCamerasNames event, Emitter<HomeState> emit) async {
  //   await RemoteProvider().getAllCamerasNames().then((value) {
  //     emit(state.copyWith(
  //         camerasNamesList: value, submission: Submission.hasData));
  //   });
  // }

  // _onGetSourceTypes(GetSourceTypes event, Emitter<HomeState> emit) async {
  //   await RemoteProvider().getAllSourceTypes().then((value) {
  //     emit(state.copyWith(
  //         sourceTypesList: value, submission: Submission.hasData));
  //   });
  // }

  // _onGetModelsName(GetModelsName event, Emitter<HomeState> emit) async {
  //   await RemoteProvider().getAllModelsNames().then((value) {
  //     emit(state.copyWith(
  //         modelsNameList: value, submission: Submission.hasData));
  //   });
  // }
  ///////////////////////////////

  /// Add Camera Handle
  // _onAddCameraEvent(AddCameraEvent event, Emitter<HomeState> emit) async {
  //   emit(state.copyWith(submission: Submission.loading));
  //   await RemoteProvider()
  //       .addCamera(
  //     cameraName: state.cameraName,
  //     sourceType: state.cameraSourceType,
  //     sourceData: state.cameraSource,
  //   )
  //       .then((value) {
  //     if (state.cameraSelectedModels.isNotEmpty) {
  //       add(const ApplyModelEvent());
  //     }
  //     if (value != AddCameraModel()) {
  //       emit(const HomeState().copyWith(submission: Submission.success));
  //     } else {
  //       emit(state.copyWith(submission: Submission.error));
  //     }
  //   });
  // }

  /// Apply Model Handle
  // _onApplyModelEvent(ApplyModelEvent event, Emitter<HomeState> emit) async {
  //   emit(state.copyWith(submission: Submission.loading));
  //   await RemoteProvider()
  //       .applyModelToCamera(
  //     cameraName: state.cameraName,
  //     modelName: state.cameraSelectedModels,
  //   )
  //       .then((value) {
  //     emit(const HomeState().copyWith(submission: Submission.success));
  //     // EasyLoading.showSuccess("value.cameraName.toString()");
  //   }).timeout(
  //     const Duration(seconds: 4),
  //     onTimeout: () {
  //       emit(const HomeState().copyWith(submission: Submission.success));
  //     },
  //   );
  // }
}
