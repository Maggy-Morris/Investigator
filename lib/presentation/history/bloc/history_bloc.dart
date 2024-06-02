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

  HistoryBloc()
      : super(HistoryState(
            pathForImages:
                PathForImages(count: 0, filePath: "", timestamp: []))) {
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
    on<EditPageNumberInsideHistoryDetails>(
        _onEditPageNumberInsideHistoryDetails);

    on<EditPageCount>(_onEditPageCount);
    on<EditPathProvided>(_onEditPathProvided);
    on<EditvideoPathForHistory>(_onEditvideoPathForHistory);
    on<SecondsGivenFromVideoEvent>(_onSecondsGivenFromVideoEvent);

    /// Date
    on<SearchByDay>(_onSearchByDay);
    on<SearchByMonth>(_onSearchByMonth);
    on<SearchByYear>(_onSearchByYear);

    on<FilterSearchDataEvent>(_onFilterSearchDataEvent);
    on<EditPageNumberFiltered>(_onEditPageNumberFiltered);
  }
  // late StreamSubscription<Uint8List> videoStreamSubscription;
  _onHistoryEvent(HistoryEvent event, Emitter<HistoryState> emit) {}

  _onSearchByDay(SearchByDay event, Emitter<HistoryState> emit) {
    emit(state.copyWith(
        selectedDay: event.selectedDay, submission: Submission.editing));
  }

  _onSearchByMonth(SearchByMonth event, Emitter<HistoryState> emit) {
    emit(state.copyWith(
        selectedMonth: event.selectedMonth, submission: Submission.editing));
  }

  _onSearchByYear(SearchByYear event, Emitter<HistoryState> emit) {
    emit(state.copyWith(
        selectedYear: event.selectedYear, submission: Submission.editing));
  }

////////////////////////////////////////////////////////////////////////////////
  _onFilterSearchDataEvent(
      FilterSearchDataEvent event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    try {
      await RemoteProvider()
          .getFilteredHistory(
        pageNumber: state.pageIndex == 0 ? 1 : state.pageIndex,
        companyName:
            AuthenticationRepository.instance.currentUser.companyName?.first,
        date:
            "${state.selectedYear}-${state.selectedMonth}-${state.selectedDay}",
      )
          .then((value) {
        // print(value.paths);
        if (value.data!.isNotEmpty) {
          emit(
            state.copyWith(
              pageCount: value.nPages,
              allHistory: value.data,
              submission: Submission.hasData,
            ),
          );
        } else {
          emit(state.copyWith(
              pageCount: 0,
              // videoPathForHistory: event.videoPathForHistory,
              allHistory: [],
              submission: Submission.noDataFound));
        }
      });
    } catch (_) {
      emit(state.copyWith(allHistory: [], submission: Submission.noDataFound));
    }
  }
  //////////////////////////////////////////////////////////////////////////////

  _onPathesDataEvent(PathesDataEvent event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    try {
      await RemoteProvider()
          .getAllPathes(
        pageNumber: state.pageIndex == 0 ? 1 : state.pageIndex,
        companyName:
            AuthenticationRepository.instance.currentUser.companyName?.first,
      )
          .then((value) {
        // print(value.paths);
        if (value.data!.isNotEmpty) {
          emit(state.copyWith(
              pageCount: value.nPages,
              allHistory: value.data,
              submission: Submission.hasData));
        } else {
          emit(state.copyWith(
              // videoPathForHistory: event.videoPathForHistory,
              allHistory: [],
              submission: Submission.noDataFound));
        }
      });
    } catch (_) {
      emit(state.copyWith(allHistory: [], submission: Submission.noDataFound));
    }
  }

  _onEditvideoPathForHistory(
      EditvideoPathForHistory event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    try {
      await RemoteProvider()
          .getHistoryDetails(
        videoPath: event.videoPathForHistory,
        companyName:
            AuthenticationRepository.instance.currentUser.companyName?.first,
      )
          .then((value) {
        // print(value.paths);
        emit(state.copyWith(
            // videoPathForHistory: event.videoPathForHistory,
            pathForImages: value.data,
            submission: Submission.hasData));
      });
    } catch (_) {
      emit(state.copyWith(
          pathForImages: null, submission: Submission.noDataFound));
    }
  }

  _onEditPageNumber(EditPageNumber event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(
        pageIndex: event.pageIndex, submission: Submission.editing));

    add(const PathesDataEvent());
  }

  _onEditPageNumberInsideHistoryDetails(
      EditPageNumberInsideHistoryDetails event,
      Emitter<HistoryState> emit) async {
    emit(state.copyWith(
        pageIndex: event.pageIndex, submission: Submission.editing));
  }

  _onEditPageNumberFiltered(
      EditPageNumberFiltered event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(
        pageIndex: event.pageIndex, submission: Submission.editing));

    add(const FilterSearchDataEvent());
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

  _onSecondsGivenFromVideoEvent(
      SecondsGivenFromVideoEvent event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(
        secondsGivenFromVideo: 0, submission: Submission.editing));
    emit(state.copyWith(
        secondsGivenFromVideo: event.secondsGivenFromVideo,
        submission: Submission.editing));
  }

  // _onVideoStreamChanged(
  //     VideoStreamChanged event, Emitter<HistoryState> emit) async {
  //   emit(state.copyWith(videoStream: event.videoStream));
  // }
}
