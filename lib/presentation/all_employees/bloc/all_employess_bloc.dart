import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/enum/enum.dart';
import 'package:Investigator/core/models/camera_details_model.dart';
import 'package:Investigator/core/models/dashboard_models.dart';
import 'package:Investigator/core/remote_provider/remote_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/add_company_model.dart';
import '../../../core/models/employee_model.dart';
import '../../../core/widgets/toast/toast.dart';

part 'all_employess_event.dart';

part 'all_employess_state.dart';

class AllEmployeesBloc extends Bloc<AllEmployeesEvent, AllEmployeesState> {
  static AllEmployeesBloc get(context) =>
      BlocProvider.of<AllEmployeesBloc>(context);

  AllEmployeesBloc() : super(AllEmployeesState()) {
    /// Main Events
    on<AllEmployeesEvent>(_onAllEmployeesEvent);
    // on<GetPersonByName>(_onGetPersonByName);

    on<GetPersonByNameEvent>(_onGetPersonByNameEvent);

    on<GetEmployeeNames>(_onGetEmployeeNames);
    on<GetEmployeeNamesEvent>(_onGetEmployeeNamesEvent);

    /// Delete
    on<DeletePersonByNameEvent>(_onDeletePersonByNameEvent);

    /// Add New Employee
    on<AddNewEmployee>(_onAddNewEmployee);
    on<AddNewEmployeeEvent>(_onAddNewEmployeeEvent);

    /// Date
    on<CameraInitializeDate>(_onCameraInitializeDate);
    on<CameraAddDay>(_onCameraAddDay);
    on<CameraAddMonth>(_onCameraAddMonth);
    on<CameraAddYear>(_onCameraAddYear);
  }

  _onAllEmployeesEvent(
      AllEmployeesEvent event, Emitter<AllEmployeesState> emit) {}

  _onGetEmployeeNames(
      GetEmployeeNames event, Emitter<AllEmployeesState> emit) async {
    await RemoteProvider();
    // .getAllEmployeeNames(companyName: state.companyName)
    // .then((value) {
    emit(state.copyWith(
        companyName: event.companyName, submission: Submission.hasData));
    // });
  }

  _onGetEmployeeNamesEvent(
      GetEmployeeNamesEvent event, Emitter<AllEmployeesState> emit) async {
    emit(state.copyWith(submission: Submission.loading));

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final String? companyName = prefs.getString('companyName');

      final employeeModel = await RemoteProvider().getAllEmployeeNames(
        // companyName: "Think" ?? "",
        companyName: companyName ?? '',
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
      debugPrint(e.toString());

      emit(state.copyWith(
        submission: Submission.error,
        employeeNamesList: [],
      ));
    }
  }

  /// New Employees Added
  _onAddNewEmployee(
      AddNewEmployee event, Emitter<AllEmployeesState> emit) async {
    emit(state.copyWith(
        companyName: event.companyName,
        personName: event.personName,
        // imageName: event.imageName,
        // files: event.files,
        image: event.image,
        submission: Submission.editing));
  }

/////////////////////////////////////////////////////////////////
  _onAddNewEmployeeEvent(
      AddNewEmployeeEvent event, Emitter<AllEmployeesState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .addNewPersonToACompany(
      companyName: state.companyName,
      personName: state.personName,
      // imageName:state.imageName,
      // image: state.files,
      image: state.image,
    )
        .then((value) {
      // if (state.cameraSelectedModels.isNotEmpty) {
      //   add(const ApplyModelEvent());
      // }
      if (value != AddCompanyModel()) {
        emit(AllEmployeesState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }

  _onCameraInitializeDate(
      CameraInitializeDate event, Emitter<AllEmployeesState> emit) {
    add(CameraAddDay(selectedDay: DateTime.now().day.toString()));
    add(CameraAddMonth(selectedMonth: DateTime.now().month.toString()));
    add(CameraAddYear(selectedYear: DateTime.now().year.toString()));
  }

  _onCameraAddDay(CameraAddDay event, Emitter<AllEmployeesState> emit) {
    emit(state.copyWith(
        selectedDay: event.selectedDay, submission: Submission.editing));
    if (state.singleCameraDetails.isNotEmpty) {
      add(GetModelsChartsData(
          modelsList: state.singleCameraDetails.first.models ?? [],
          cameraName: state.singleCameraDetails.first.cameraName ?? ""));
    }
  }

  /// Delete person data by Name
  _onDeletePersonByNameEvent(
      DeletePersonByNameEvent event, Emitter<AllEmployeesState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? companyName = prefs.getString('companyName');
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .deleteDocumentByName(
      companyName: companyName ?? '',
      personName: event.personName,
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

  /// Add GetPersonByName
  // _onGetPersonByName(
  //     GetPersonByName event, Emitter<AllEmployeesState> emit) async {
  //   await RemoteProvider();
  //   //     .getPersonByName(
  //   //         companyName: state.companyName, personName: state.personName)
  //   //     .then((value) {
  //   emit(state.copyWith(
  //       companyName: event.companyName, submission: Submission.hasData));
  //   // });
  // }

  /// Add GetPersonByName Handle
  _onGetPersonByNameEvent(
      GetPersonByNameEvent event, Emitter<AllEmployeesState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .getPersonByName(
      companyName: event.companyName,
      personName: event.personName,
    )
        .then((value) {
      // if (state.companyName.isNotEmpty) {
      //   add(const ApplyModelEvent());
      // }
      if (value != EmployeeModel()) {
        // Update the employeeNamesList with the new list of employees
        emit(state.copyWith(
          submission: Submission.success,
          employeeNamesList: value,
        ));

        // final updatedList = state.employeeNamesList
        //     .where((employee) => employee.name != event.personName)
        //     .toList();
        // emit(HomeState().copyWith(
        //   submission: Submission.success,
        //   employeeNamesList: updatedList,
        // ));
      } else if (value.length == 0) {
        emit(state.copyWith(
          submission: Submission.noDataFound,
        ));
      } else {
        emit(state.copyWith(
          submission: Submission.error,
        ));
      }
    });
  }

  // _onCameraDetailsEvent(
  //     CameraDetailsEvent event, Emitter<AllEmployeesState> emit) async {
  //   emit(state.copyWith(submission: Submission.loading));
  //   try {
  //     await RemoteProvider()
  //         // .getAllCamerasDetails(cameraName: event.cameraName)
  //         // .then((value) {
  //       emit(state.copyWith(
  //           singleCameraDetails: [value], submission: Submission.success));

  //       /// get models Data
  //       add(GetModelsChartsData(
  //           modelsList: value.models ?? [], cameraName: event.cameraName));
  //     });
  //   } catch (_) {
  //     emit(state
  //         .copyWith(singleCameraDetails: [], submission: Submission.error));
  //   }
  // }

  // _onGetModelsChartsData(
  //     GetModelsChartsData event, Emitter<AllEmployeesState> emit) async {
  //   emit(state.copyWith(submission: Submission.loading));
  //   try {
  //     await RemoteProvider()
  //         .getAllCamerasCountsPerHourForDashboard(
  //       cameraName: event.cameraName,
  //       day: state.selectedDay,
  //       month: state.selectedMonth,
  //       year: state.selectedYear,
  //     )
  //         .then((value) {
  //       emit(state.copyWith(
  //           camerasCountsPerHour: [value], submission: Submission.success));
  //     });
  //   } catch (_) {
  //     emit(state
  //         .copyWith(singleCameraDetails: [], submission: Submission.error));
  //   }
  // }

  _onCameraAddMonth(CameraAddMonth event, Emitter<AllEmployeesState> emit) {
    emit(state.copyWith(
        selectedMonth: event.selectedMonth, submission: Submission.editing));
  }

  _onCameraAddYear(CameraAddYear event, Emitter<AllEmployeesState> emit) {
    emit(state.copyWith(
        selectedYear: event.selectedYear, submission: Submission.editing));
  }

  // _onCameraMainDataEvent(
  //     CameraMainDataEvent event, Emitter<AllEmployeesState> emit) async {
  //   try {
  //     await RemoteProvider().getAllCamerasNames().then((value) {
  //       emit(state.copyWith(allCameras: value));
  //     });
  //     // if (state.allCameras.isNotEmpty) {
  //     //   add(const CameraGetAllCamerasCounts());
  //     // }
  //   } catch (_) {
  //     emit(state.copyWith(allCameras: []));
  //   }
  //   if (state.allCameras.isNotEmpty) {
  //     for (var element in state.allCameras) {
  //       try {
  //         await RemoteProvider()
  //             .getAllCamerasDetails(cameraName: element)
  //             .then((value) {
  //           emit(state
  //               .copyWith(camerasDetails: [...state.camerasDetails, value]));
  //         });
  //       } catch (_) {}
  //     }
  //   }
  // }
}
