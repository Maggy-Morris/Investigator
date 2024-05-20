import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/enum/enum.dart';
// import 'package:Investigator/core/models/add_camera_model.dart';
import 'package:Investigator/core/remote_provider/remote_provider.dart';

import '../../../authentication/authentication_repository.dart';
import '../../../core/models/add_company_model.dart';
import '../../../core/models/employee_model.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static HomeBloc get(context) => BlocProvider.of<HomeBloc>(context);
  String companyNameRepo =
      AuthenticationRepository.instance.currentUser.companyName?.first ?? "";
  HomeBloc() : super(HomeState()) {
    on<HomeEvent>(_onHomeEvent);
    // on<DataEvent>(_onDataEvent);

    /// change fields events
    on<AddCompanyEvent>(_onAddCompanyEvent);
    on<DeleteCompanyEvent>(_onDeleteCompanyEvent);

    // /// Add New Employee

    on<reloadSnapShots>(_onreloadSnapShots);
    on<reloadPath>(_onreloadPath);

    on<GetAccuracy>(_onGetAccuracy);

    on<imagesList>(_onimagesList);

    on<imageevent>(_onimageevent);
    on<videoevent>(_onvideoevent);
    on<getPersonName>(_ongetPersonName);

    /// functionality Company get employees Data
    // on<GetPersonByNameEvent>(_onGetPersonByNameEvent);
    on<GetPersonByIdEvent>(_onGetPersonByIdEvent);
    on<AddCompanyName>(_onAddCompanyName);

    /// functionality Company delete employees Data
    on<SearchForEmployeeByVideoEvent>(_onSearchForEmployeeByVideoEvent);
    on<ImageToSearchForEmployee>(_onImageToSearchForEmployee);
    on<EditPageNumber>(_onEditPageNumber);
    // on<GetPaginatedFramesEvent>(_onGetPaginatedFramesEvent);
    on<EditPageCount>(_onEditPageCount);
    on<SetTimeDuration>(_onSetTimeDuration);

    // on<DeletePersonByNameEvent>(_onDeletePersonByNameEvent);
    on<DeletePersonByIdEvent>(_onDeletePersonByIdEvent);
  }

  _onHomeEvent(HomeEvent event, Emitter<HomeState> emit) async {}

  // _onDataEvent(DataEvent event, Emitter<HomeState> emit) async {
  //   add(const GetCamerasNames());
  //   add(const GetSourceTypes());
  //   add(const GetModelsName());
  // }

  _onSetTimeDuration(SetTimeDuration event, Emitter<HomeState> emit) async {
    emit(state.copyWith(timeDuration: 0, submission: Submission.editing));
    emit(state.copyWith(
        timeDuration: event.timeDuration, submission: Submission.editing));

    // add(const GetEmployeeNamesEvent());
  }

  _onEditPageNumber(EditPageNumber event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        pageIndex: event.pageIndex, submission: Submission.editing));

    // add(const GetEmployeeNamesEvent());
  }

  _onEditPageCount(EditPageCount event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        pageCount: event.pageCount, submission: Submission.editing));
  }

  _onImageToSearchForEmployee(
      ImageToSearchForEmployee event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        imageWidget: event.imageWidget, submission: Submission.loading));
    // Your logic here to fetch data and determine the imageWidget
  }

  _ongetPersonName(getPersonName event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        personName: event.personName, submission: Submission.editing));
  }

  _onGetAccuracy(GetAccuracy event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        accuracy: event.accuracy, submission: Submission.editing));
  }

  _onreloadSnapShots(reloadSnapShots event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        snapShots: event.snapyy, submission: Submission.editing));
  }

  _onreloadPath(reloadPath event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        pathProvided: event.path_provided, submission: Submission.editing));
  }

  _onAddCompanyName(AddCompanyName event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        companyName: event.companyName, submission: Submission.editing));
  }

  _onimageevent(imageevent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        imageFile: event.imageFile, submission: Submission.editing));
  }

  _onimagesList(imagesList event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        imagesListdata: event.imagesListdata, submission: Submission.editing));
  }

  _onvideoevent(videoevent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(video: event.video, submission: Submission.editing));
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
      similarityScore: state.accuracy,
      video: state.video,
      companyName: companyNameRepo,
      images: state.imagesListdata,
      // personName: state.personName,
      // image: state.image,
    )
        .then((value) {
      if (value.found == true) {
        emit(state.copyWith(
          pathProvided: value.global_path,
          pageCount: value.response_count,
          submission: Submission.success,
          data: value.data,
          // snapShots: value.snapshot_list,
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

  ///paginated frames handling

  // _onGetPaginatedFramesEvent(
  //     GetPaginatedFramesEvent event, Emitter<HomeState> emit) async {
  //   emit(state.copyWith(submission: Submission.loading));

  //   try {
  //     final employeeModel = await RemoteProvider().getPaginationPagesForFrames(
  //       pathProvided: state.pathProvided,
  //       pageNumber:
  //           state.pageIndex == 0 ? state.pageIndex + 1 : state.pageIndex,
  //     );

  // if (state.pageCount == 0) {
  //   emit(state.copyWith(
  //     pageCount: employeeModel.nPages,
  //   ));
  // }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //     if (employeeModel.data!.isNotEmpty) {
  //       emit(state.copyWith(
  //         // submission: Submission.success,
  //         employeeNamesList: employeeModel.data,
  //         // count: employeeModel.count,
  //         pageCount: employeeModel.nPages,
  //       ));
  //     } else {
  //       emit(state.copyWith(
  //         // submission: Submission.noDataFound,
  //         employeeNamesList: [],
  //       ));
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());

  //     emit(state.copyWith(
  //       submission: Submission.error,
  //       employeeNamesList: [],
  //     ));
  //   }
  // }

// _onUpdateRoomsEvent(
//       UpdateRoomsEvent event, Emitter<HomeState> emit) async {
//     List<PlatformFile> newList = state.roomNAMS;
//     if (event.roomNames != null) {
//       if (event.roomNames?.isNotEmpty ?? false) {
//         newList[event.index] = event.roomNames ?? "";

//         emit(state.copyWith(
//           roomNAMS: newList,
//           // room_numbers: event.room_num,
//           // submission: Submission.hasData,
//         ));
//       }
//     } else {
//       newList.removeAt(event.index);
//       emit(state.copyWith(
//         roomNAMS: newList,
//       ));
//     }
//   }
}
