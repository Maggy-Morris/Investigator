import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/enum/enum.dart';
// import 'package:Investigator/core/models/camera_details_model.dart';
// import 'package:Investigator/core/models/dashboard_models.dart';
import 'package:Investigator/core/remote_provider/remote_provider.dart';

import '../../../authentication/authentication_repository.dart';
// import '../../../core/models/add_company_model.dart';
import '../../../core/models/employee_model.dart';

part 'all_employess_event.dart';

part 'all_employess_state.dart';

class AllEmployeesBloc extends Bloc<AllEmployeesEvent, AllEmployeesState> {
  String companyNameRepo =
      AuthenticationRepository.instance.currentUser.companyName?.first ?? "";
  static AllEmployeesBloc get(context) =>
      BlocProvider.of<AllEmployeesBloc>(context);

  AllEmployeesBloc() : super(AllEmployeesState()) {
    /// Main Events
    on<AllEmployeesEvent>(_onAllEmployeesEvent);
    // on<GetPersonByName>(_onGetPersonByName);

    on<GetPersonByNameEvent>(_onGetPersonByNameEvent);

    // on<GetEmployeeNames>(_onGetEmployeeNames);
    on<GetEmployeeNamesEvent>(_onGetEmployeeNamesEvent);

    /// Delete
    on<DeletePersonByNameEvent>(_onDeletePersonByNameEvent);

    /// Add New Employee
    on<AddNewEmployee>(_onAddNewEmployee);
    on<AddNewEmployeeEvent>(_onAddNewEmployeeEvent);

    on<AddpersonName>(_onAddpersonName);
    on<AddphoneNum>(_onAddphoneNum);
    on<Addemail>(_onAddemail);
    on<AdduserId>(_onAdduserId);

    on<imageevent>(_onimageevent);
    on<EditPageNumber>(_onEditPageNumber);
    on<checkBox>(_oncheckBox);
    on<Check>(_onCheck);

//edit

    on<UpdateEmployeeEvent>(_onUpdateEmployeeEvent);
    on<RadioButtonChanged>(_onRadioButtonChanged);

    /// Date
    // on<CameraAddDay>(_onCameraAddDay);
    // on<CameraAddMonth>(_onCameraAddMonth);
    // on<CameraAddYear>(_onCameraAddYear);
  }

  _onImageWidget(ImageWidget event, Emitter<AllEmployeesState> emit) async {
    emit(state.copyWith(
        imageWidget: event.imageWidget, submission: Submission.loading));
    // Your logic here to fetch data and determine the imageWidget
  }

  _onCheck(Check event, Emitter<AllEmployeesState> emit) async {
    emit(state.copyWith(check: event.check, submission: Submission.editing));
  }

  _oncheckBox(checkBox event, Emitter<AllEmployeesState> emit) async {
    emit(state.copyWith(
        roomNAMS: event.room_NMs, submission: Submission.editing));
  }

  _onEditPageNumber(
      EditPageNumber event, Emitter<AllEmployeesState> emit) async {
    emit(state.copyWith(
        pageIndex: event.pageIndex, submission: Submission.editing));
    add(const GetEmployeeNamesEvent());
  }

  _onimageevent(imageevent event, Emitter<AllEmployeesState> emit) async {
    emit(state.copyWith(
        imageFile: event.imageFile, submission: Submission.editing));
  }

  _onAllEmployeesEvent(
      AllEmployeesEvent event, Emitter<AllEmployeesState> emit) {}

  _onAddpersonName(AddpersonName event, Emitter<AllEmployeesState> emit) async {
    emit(state.copyWith(
      personName: event.personName,
      submission: Submission.hasData,
    ));
    _onAddNewEmployee(
        AddNewEmployee(
          companyName: state.companyName,
          personName: event.personName,
          image: state.image,
          phoneNum: state.phoneNum,
          email: state.email,
          userId: state.userId,
        ),
        emit);
  }

  _onAddphoneNum(AddphoneNum event, Emitter<AllEmployeesState> emit) async {
    // .getAllEmployeeNames(companyName: state.companyName)
    // .then((value) {
    emit(state.copyWith(
        phoneNum: event.phoneNum, submission: Submission.hasData));

    _onAddNewEmployee(
        AddNewEmployee(
          companyName: state.companyName,
          personName: state.personName,
          image: state.image,
          phoneNum: event.phoneNum,
          email: state.email,
          userId: state.userId,
        ),
        emit);
    // });
  }

  _onAddemail(Addemail event, Emitter<AllEmployeesState> emit) async {
    // .getAllEmployeeNames(companyName: state.companyName)
    // .then((value) {
    emit(state.copyWith(email: event.email, submission: Submission.hasData));
    // });
    _onAddNewEmployee(
        AddNewEmployee(
          companyName: state.companyName,
          personName: state.personName,
          image: state.image,
          phoneNum: state.phoneNum,
          email: event.email,
          userId: state.userId,
        ),
        emit);
  }

  _onAdduserId(AdduserId event, Emitter<AllEmployeesState> emit) async {
    // .getAllEmployeeNames(companyName: state.companyName)
    // .then((value) {
    emit(state.copyWith(userId: event.userId, submission: Submission.hasData));
    // });
    _onAddNewEmployee(
        AddNewEmployee(
          companyName: state.companyName,
          personName: state.personName,
          image: state.image,
          phoneNum: state.phoneNum,
          email: state.email,
          userId: event.userId,
        ),
        emit);
  }
  ///////////////////////////////////////////////////

  // _onGetEmployeeNames(
  //     GetEmployeeNames event, Emitter<AllEmployeesState> emit) async {
  //   // await RemoteProvider();
  //   // .getAllEmployeeNames(companyName: state.companyName)
  //   // .then((value) {
  //   emit(state.copyWith(
  //       companyName: event.companyName, submission: Submission.hasData));
  //   // });
  // }

  _onGetEmployeeNamesEvent(
      GetEmployeeNamesEvent event, Emitter<AllEmployeesState> emit) async {
    emit(state.copyWith(submission: Submission.loading));

    try {
      final employeeModel = await RemoteProvider().getAllEmployeeNames(
        companyName: companyNameRepo,
        pageNumber:
            state.pageIndex == 0 ? state.pageIndex + 1 : state.pageIndex,
      );

      if (state.pageCount == 0) {
        emit(state.copyWith(
          pageCount: employeeModel.nPages,
        ));
      }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if (employeeModel.data!.isNotEmpty) {
        emit(state.copyWith(
          // submission: Submission.success,
          employeeNamesList: employeeModel.data,
          count: employeeModel.count,
        ));
      } else {
        emit(state.copyWith(
          // submission: Submission.noDataFound,
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
    // await RemoteProvider();

    //   add(const GetCamerasNames());

    emit(state.copyWith(
        companyName: event.companyName,
        personName: event.personName,
        image: event.image,
        phoneNum: event.phoneNum,
        email: event.email,
        userId: event.userId,
        submission: Submission.editing));
  }

/////////////////////////////////////////////////////////////////
  ///
  _onAddNewEmployeeEvent(
      AddNewEmployeeEvent event, Emitter<AllEmployeesState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    try {
      final result = await RemoteProvider().addNewPersonToACompany(
          companyName: companyNameRepo,
          personName: state.personName,
          phoneNum: state.phoneNum,
          email: state.email,
          userId: state.userId,
          image: state.image,
          blackListed: state.selectedOption,
          roomNamesChoosen: state.roomNAMS);
      if (result.success == true) {
        emit(state.copyWith(
            submission: Submission.success, responseMessage: result.message));
        // add(const GetEmployeeNamesEvent());
      } else {
        emit(state.copyWith(
            submission: Submission.error, responseMessage: result.message));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(submission: Submission.error));
    }
  }

  _onUpdateEmployeeEvent(
      UpdateEmployeeEvent event, Emitter<AllEmployeesState> emit) async {
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
        add(const GetEmployeeNamesEvent());
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(submission: Submission.error));
    }
  }

  /// Delete person data by Name
  _onDeletePersonByNameEvent(
      DeletePersonByNameEvent event, Emitter<AllEmployeesState> emit) async {
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
        // final updatedList = state.employeeNamesList
        //     .where((employee) => employee.name != event.personName)
        //     .toList();
        emit(state.copyWith(
            submission: Submission.success,
            // employeeNamesList: state.employeeNamesList,
            responseMessage: value.data));
        add(const GetEmployeeNamesEvent());
      } else if (value.data == "No documents found for deletion.") {
        emit(state.copyWith(
          submission: Submission.noDataFound,
          responseMessage: value.data,
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
        if (value.length == 0) {
          emit(state.copyWith(
            submission: Submission.noDataFound,
          ));
        }
      }
      // else if (value.length == 0) {
      //   emit(state.copyWith(
      //     submission: Submission.noDataFound,
      //   ));
      // }
      else {
        emit(state.copyWith(
          submission: Submission.error,
        ));
      }
    });
  }

//RadioButton
  _onRadioButtonChanged(
      RadioButtonChanged event, Emitter<AllEmployeesState> emit) async {
    emit(
      state.copyWith(
        selectedOption: event.selectedOption,
        showTextField: event.showTextField,
      ),
    );
  }
}
