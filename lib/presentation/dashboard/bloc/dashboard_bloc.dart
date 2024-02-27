import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/models/dashboard_models.dart';
import 'package:Investigator/core/remote_provider/remote_provider.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  static DashboardBloc get(context) => BlocProvider.of<DashboardBloc>(context);

  DashboardBloc() : super(const DashboardState()) {
    /// Main Events
    on<DashboardEvent>(_onDashboardEvent);
    on<DashboardMainDataEvent>(_onDashboardMainDataEvent);

    /// Get Data
    on<DashboardGetAllCamerasCounts>(_onDashboardGetAllCamerasCounts);
    on<DashboardGetAllCamerasStatistics>(_onDashboardGetAllCamerasStatistics);

    /// update date
    on<DashboardInitializeDate>(_onDashboardInitializeDate);
    on<DashboardAddDay>(_onDashboardAddDay);
    on<DashboardAddMonth>(_onDashboardAddMonth);
    on<DashboardAddYear>(_onDashboardAddYear);
  }

  _onDashboardEvent(DashboardEvent event, Emitter<DashboardState> emit) {}

  _onDashboardInitializeDate(DashboardInitializeDate event, Emitter<DashboardState> emit) {
    add(DashboardAddDay(selectedDay: DateTime.now().day.toString()));
    add(DashboardAddMonth(selectedMonth: DateTime.now().month.toString()));
    add(DashboardAddYear(selectedYear: DateTime.now().year.toString()));
  }

  _onDashboardAddDay(DashboardAddDay event, Emitter<DashboardState> emit) {
    emit(state.copyWith(selectedDay: event.selectedDay));
    add(const DashboardGetAllCamerasStatistics());
  }

  _onDashboardAddMonth(DashboardAddMonth event, Emitter<DashboardState> emit) {
    emit(state.copyWith(selectedMonth: event.selectedMonth));
  }

  _onDashboardAddYear(DashboardAddYear event, Emitter<DashboardState> emit) {
    emit(state.copyWith(selectedYear: event.selectedYear));
  }


  

  _onDashboardMainDataEvent(
      DashboardMainDataEvent event, Emitter<DashboardState> emit) async {
    try {
      await RemoteProvider().getAllCamerasNames().then((value) {
        emit(state.copyWith(allCameras: value));
      });
      if (state.allCameras.isNotEmpty) {
        add(const DashboardGetAllCamerasCounts());
      }
    } catch (_) {
      emit(state.copyWith(allCameras: []));
    }
  }

  _onDashboardGetAllCamerasCounts(
      DashboardGetAllCamerasCounts event, Emitter<DashboardState> emit) async {
    try {
      for (var element in state.allCameras) {
        try {
          await RemoteProvider()
              .getAllCamerasCountsForDashboard(cameraName: element)
              .then((value) {
            emit(state.copyWith(
              camerasCounts: [...state.camerasCounts, value],
            ));
          });
        } catch (_) {}
      }
      add(const DashboardGetAllCamerasStatistics());
    } catch (_) {}
  }

  _onDashboardGetAllCamerasStatistics(DashboardGetAllCamerasStatistics event, Emitter<DashboardState> emit) async {
    try {
      emit(state.copyWith(
        camerasCountsPerHour: [],
      ));
      for (var element in state.allCameras) {
        await RemoteProvider()
          .getAllCamerasCountsPerHourForDashboard(
        cameraName: element,
        day: state.selectedDay,
        month: state.selectedMonth,
        year: state.selectedYear,
      )
          .then((value) {
        if (value.isNotEmpty) {
          emit(state.copyWith(
            camerasCountsPerHour: [...state.camerasCountsPerHour, value],
          ));
        }
      });
      }
    } catch (_) {}
  }
}
