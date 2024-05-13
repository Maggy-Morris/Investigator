import 'package:Investigator/authentication/authentication_repository.dart';
import 'package:Investigator/core/models/history_screen_model.dart';
import 'package:Investigator/core/models/pathes_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/enum.dart';
import '../../../core/models/camera_details_model.dart';
import '../../../core/models/dashboard_models.dart';
import '../../../core/remote_provider/remote_provider.dart';

part 'history_event.dart';

part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  static HistoryBloc get(context) => BlocProvider.of<HistoryBloc>(context);

  HistoryBloc() : super( HistoryState(pathForImages: PathForImages(count: 0, filePath: "" ,timestamp: []))) {
    /// Main Events
    on<HistoryEvent>(_onHistoryEvent);
    on<PathesDataEvent>(_onPathesDataEvent);
    // on<VideoStreamChanged>(_onVideoStreamChanged);

    /// Get Data
    // on<CameraDetailsEvent>(_onCameraDetailsEvent);
    // on<GetModelsChartsData>(_onGetModelsChartsData);
    // on<CameraGetAllCamerasCounts>(_onCameraGetAllCamerasCounts);
    // on<CameraGetAllCamerasStatistics>(_onCameraGetAllCamerasStatistics);
    //Stop processing camera
    on<EditPageNumber>(_onEditPageNumber);
    on<EditPageCount>(_onEditPageCount);
    on<EditPathProvided>(_onEditPathProvided);
    on<EditvideoPathForHistory>(_onEditvideoPathForHistory);

    /// Date
    // on<CameraInitializeDate>(_onCameraInitializeDate);
  }
  // late StreamSubscription<Uint8List> videoStreamSubscription;
  _onHistoryEvent(HistoryEvent event, Emitter<HistoryState> emit) {}

  // _onCameraInitializeDate(
  //     CameraInitializeDate event, Emitter<HistoryState> emit) {}

  // _onCameraDetailsEvent(
  //     CameraDetailsEvent event, Emitter<HistoryState> emit) async {
  //   emit(state
  //       .copyWith(singleCameraDetails: [], submission: Submission.loading));
  //   try {
  //     await RemoteProvider()
  //         .getAllCamerasDetails(cameraName: event.cameraName)
  //         .then((value) {
  //       emit(state.copyWith(
  //         singleCameraDetails: [value],
  //         // submission: Submission.success
  //       ));

  //       /// get models Data
  //       // if(state.singleCameraDetails.first.models?.contains("")??false) {
  //       add(GetModelsChartsData(
  //           modelsList: value.models ?? [], cameraName: event.cameraName));
  //       // }
  //     });
  //   } catch (_) {
  //     emit(state
  //         .copyWith(singleCameraDetails: [], submission: Submission.error));
  //   }

  //   ///
  //   // onStreamVideo(event.cameraName);
  //   ///
  //   // await RemoteProvider()
  //   //     .getDisplayStream(cameraName: event.cameraName).then((value) {
  //   //   add(VideoStreamChanged(videoStream: value));
  //   //   // emit(state.copyWith(
  //   //   //       videoStream: value, submission: Submission.success));
  //   // });
  // }

  // _onGetModelsChartsData(
  //     GetModelsChartsData event, Emitter<HistoryState> emit) async {
  //   emit(state.copyWith(submission: Submission.loading));
  //   try {
  //     await RemoteProvider()
  //         .getAllCamerasCountsPerHourForDashboard(
  //       cameraName: event.cameraName,
  //       // minute: state.selectedMinute,
  //       // hour: state.selectedHour,
  //       // startDay: state.selectedStartDay,
  //       // endDay: state.selectedEndDay,
  //       // day: state.selectedDay,
  //       // startMonth: state.selectedStartMonth,
  //       // endMonth: state.selectedEndMonth,
  //       // month: state.selectedMonth,
  //       // startYear: state.selectedStartYear,
  //       // endYear: state.selectedEndYear,
  //       // year: state.selectedYear,
  //     )
  //         .then((value) {
  //       emit(state.copyWith(
  //         camerasCountsPerHour: [value],
  //         //  submission: Submission.success
  //       ));
  //     });
  //   } catch (_) {
  //     emit(state
  //         .copyWith(camerasCountsPerHour: [], submission: Submission.error));
  //   }
  // }

  _onPathesDataEvent(PathesDataEvent event, Emitter<HistoryState> emit) async {
    // try {
    //   await RemoteProvider().getAllCamerasNames().then((value) {
    //     emit(state.copyWith(allCameras: value));
    //   });
    //   // if (state.allCameras.isNotEmpty) {
    //   //   add(const CameraGetAllCamerasCounts());
    //   // }
    // } catch (_) {
    //   emit(state.copyWith(allCameras: []));
    // }
    emit(state.copyWith(submission: Submission.loading));
    try {
      await RemoteProvider()
          .getAllPathes(
        companyName:
            AuthenticationRepository.instance.currentUser.companyName?.first,
      )
          .then((value) {
        // print(value.paths);
        emit(state.copyWith(
            allHistory: value.data, submission: Submission.hasData));
      });
    } catch (_) {
      emit(state
          .copyWith(camerasDetails: [], submission: Submission.noDataFound));
    }
  }

  _onEditvideoPathForHistory(
      EditvideoPathForHistory event, Emitter<HistoryState> emit) async {
    // try {
    //   await RemoteProvider().getAllCamerasNames().then((value) {
    //     emit(state.copyWith(allCameras: value));
    //   });
    //   // if (state.allCameras.isNotEmpty) {
    //   //   add(const CameraGetAllCamerasCounts());
    //   // }
    // } catch (_) {
    //   emit(state.copyWith(allCameras: []));
    // }
    emit(state.copyWith(submission: Submission.loading));
    try {
      await RemoteProvider()
          .getHistoryDetails(
        video_Path: event.videoPathForHistory,
        companyName:
            AuthenticationRepository.instance.currentUser.companyName?.first,
      )
          .then((value) {
        // print(value.paths);
        emit(state.copyWith(
            pathForImages: value.data, submission: Submission.hasData));
      });
    } catch (_) {
      emit(state
          .copyWith(camerasDetails: [], submission: Submission.noDataFound));
    }
  }

  _onEditPageNumber(EditPageNumber event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(
        pageIndex: event.pageIndex, submission: Submission.editing));

    // add(const GetEmployeeNamesEvent());
  }

  _onEditPathProvided(
      EditPathProvided event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(
        pathProvided: event.pathProvided, submission: Submission.editing));

    // add(const GetEmployeeNamesEvent());
  }

  _onEditPageCount(EditPageCount event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(
        pageCount: event.pageCount, submission: Submission.editing));
  }

  // _onVideoStreamChanged(
  //     VideoStreamChanged event, Emitter<HistoryState> emit) async {
  //   emit(state.copyWith(videoStream: event.videoStream));
  // }
}
