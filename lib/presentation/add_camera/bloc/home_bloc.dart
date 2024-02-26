import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luminalens/core/enum/enum.dart';
import 'package:luminalens/core/models/add_camera_model.dart';
import 'package:luminalens/core/remote_provider/remote_provider.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static HomeBloc get(context) => BlocProvider.of<HomeBloc>(context);
  HomeBloc() : super(const HomeState()) {
    on<HomeEvent>(_onHomeEvent);
    on<DataEvent>(_onDataEvent);

    /// change fields events
    ///
    on<AddCameraName>(_onAddCameraName);
    on<AddCameraSource>(_onAddCameraSource);
    on<AddCameraSourceType>(_onAddCameraSourceType);
    on<AddCameraSourceModels>(_onAddCameraSourceModels);

    /// get static list
    on<GetCamerasNames>(_onGetCamerasNames);
    on<GetSourceTypes>(_onGetSourceTypes);
    on<GetModelsName>(_onGetModelsName);

    /// functionality cameras
    on<AddCameraEvent>(_onAddCameraEvent);
    on<ApplyModelEvent>(_onApplyModelEvent);

  }

  _onHomeEvent(HomeEvent event, Emitter<HomeState> emit) async {}

  _onDataEvent(DataEvent event, Emitter<HomeState> emit) async {
    add(const GetCamerasNames());
    add(const GetSourceTypes());
    add(const GetModelsName());
  }

  /// handle functionality events
  _onAddCameraName(AddCameraName event, Emitter<HomeState> emit) async {
    emit(state.copyWith(cameraName: event.cameraName,submission: Submission.editing));
  }
  _onAddCameraSource(AddCameraSource event, Emitter<HomeState> emit) async {
    emit(state.copyWith(cameraSource: event.cameraSource,submission: Submission.editing));
  }
  _onAddCameraSourceType(AddCameraSourceType event, Emitter<HomeState> emit) async {
    emit(state.copyWith(cameraSourceType: event.cameraSourceType,submission: Submission.editing));
  }
  _onAddCameraSourceModels(AddCameraSourceModels event, Emitter<HomeState> emit) async {
    emit(state.copyWith(cameraSelectedModels: event.cameraSelectedModels,submission: Submission.editing));
  }

  /// get static lists
  _onGetCamerasNames(GetCamerasNames event, Emitter<HomeState> emit) async {
    await RemoteProvider().getAllCamerasNames().then((value) {
      emit(state.copyWith(camerasNamesList: value,submission: Submission.hasData));
    });
  }

  _onGetSourceTypes(GetSourceTypes event, Emitter<HomeState> emit) async {
    await RemoteProvider().getAllSourceTypes().then((value) {
      emit(state.copyWith(sourceTypesList: value,submission: Submission.hasData));
    });
  }

  _onGetModelsName(GetModelsName event, Emitter<HomeState> emit) async {
    await RemoteProvider().getAllModelsNames().then((value) {
      emit(state.copyWith(modelsNameList: value,submission: Submission.hasData));
    });
  }

  /// Add Camera Handle
  _onAddCameraEvent(AddCameraEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .addCamera(
      cameraName: state.cameraName,
      sourceType: state.cameraSourceType,
      sourceData: state.cameraSource,
    ).then((value) {
      if(state.cameraSelectedModels.isNotEmpty){
        add(const ApplyModelEvent());
      }
      if(value != AddCameraModel()){
        emit(const HomeState().copyWith(submission: Submission.success));
      }else{
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }

  /// Apply Model Handle
  _onApplyModelEvent(ApplyModelEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .applyModelToCamera(
      cameraName: state.cameraName,
      modelName: state.cameraSelectedModels,
    ).then((value) {
      emit(const HomeState().copyWith(submission: Submission.success));
      // EasyLoading.showSuccess("value.cameraName.toString()");
    }).timeout(const Duration(seconds: 4),onTimeout: () {
          emit(const HomeState().copyWith(submission: Submission.success));
    },);
  }
}
