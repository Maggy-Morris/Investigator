import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/enum/enum.dart';
import 'package:Investigator/core/models/camera_details_model.dart';
import 'package:Investigator/core/models/dashboard_models.dart';
import 'package:Investigator/core/remote_provider/remote_provider.dart';

part 'camera_event.dart';

part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  static CameraBloc get(context) => BlocProvider.of<CameraBloc>(context);

  CameraBloc() : super(const CameraState()) {
    /// Main Events
    on<CameraEvent>(_onCameraEvent);
    // on<CameraMainDataEvent>(_onCameraMainDataEvent);

    /// Get Data
    on<CameraDetailsEvent>(_onCameraDetailsEvent);
    on<GetModelsChartsData>(_onGetModelsChartsData);
    // on<CameraGetAllCamerasCounts>(_onCameraGetAllCamerasCounts);
    // on<CameraGetAllCamerasStatistics>(_onCameraGetAllCamerasStatistics);

    /// Date
    on<CameraInitializeDate>(_onCameraInitializeDate);
    on<CameraAddDay>(_onCameraAddDay);
    on<CameraAddMonth>(_onCameraAddMonth);
    on<CameraAddYear>(_onCameraAddYear);
  }

  _onCameraEvent(CameraEvent event, Emitter<CameraState> emit) {}

  _onCameraInitializeDate(
      CameraInitializeDate event, Emitter<CameraState> emit) {
    add(CameraAddDay(selectedDay: DateTime.now().day.toString()));
    add(CameraAddMonth(selectedMonth: DateTime.now().month.toString()));
    add(CameraAddYear(selectedYear: DateTime.now().year.toString()));
  }

  _onCameraAddDay(CameraAddDay event, Emitter<CameraState> emit) {
    emit(state.copyWith(
        selectedDay: event.selectedDay, submission: Submission.editing));
    if (state.singleCameraDetails.isNotEmpty) {
      add(GetModelsChartsData(
          modelsList: state.singleCameraDetails.first.models ?? [],
          cameraName: state.singleCameraDetails.first.cameraName ?? ""));
    }
  }

  _onCameraDetailsEvent(
      CameraDetailsEvent event, Emitter<CameraState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    try {
      await RemoteProvider()
          .getAllCamerasDetails(cameraName: event.cameraName)
          .then((value) {
        emit(state.copyWith(
            singleCameraDetails: [value], submission: Submission.success));

        /// get models Data
        add(GetModelsChartsData(
            modelsList: value.models ?? [], cameraName: event.cameraName));
      });
    } catch (_) {
      emit(state
          .copyWith(singleCameraDetails: [], submission: Submission.error));
    }
  }

  _onGetModelsChartsData(
      GetModelsChartsData event, Emitter<CameraState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    try {
      await RemoteProvider()
          .getAllCamerasCountsPerHourForDashboard(
        cameraName: event.cameraName,
        day: state.selectedDay,
        month: state.selectedMonth,
        year: state.selectedYear,
      )
          .then((value) {
        emit(state.copyWith(
            camerasCountsPerHour: [value], submission: Submission.success));
      });
    } catch (_) {
      emit(state
          .copyWith(singleCameraDetails: [], submission: Submission.error));
    }
  }

  _onCameraAddMonth(CameraAddMonth event, Emitter<CameraState> emit) {
    emit(state.copyWith(
        selectedMonth: event.selectedMonth, submission: Submission.editing));
  }

  _onCameraAddYear(CameraAddYear event, Emitter<CameraState> emit) {
    emit(state.copyWith(
        selectedYear: event.selectedYear, submission: Submission.editing));
  }

  // _onCameraMainDataEvent(
  //     CameraMainDataEvent event, Emitter<CameraState> emit) async {
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
