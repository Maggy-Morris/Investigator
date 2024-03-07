import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/enum.dart';
import '../../../core/remote_provider/remote_provider.dart';

part 'search_by_image_event.dart';
part 'search_by_image_state.dart';

class SearchByImageBloc extends Bloc<SearchByImageEvent, SearchByImageState> {
  static SearchByImageBloc get(context) =>
      BlocProvider.of<SearchByImageBloc>(context);

  SearchByImageBloc() : super(SearchByImageState()) {
    on<SearchByImageEvent>((event, emit) {});

    on<SearchForEmployee>(_onSearchForEmployee);
    on<SearchForEmployeeEvent>(_onSearchForEmployeeEvent);
  }

  _onSearchForEmployee(
      SearchForEmployee event, Emitter<SearchByImageState> emit) async {
    // .getAllEmployeeNames(companyName: state.companyName)
    // .then((value) {
    emit(state.copyWith(
        companyName: event.companyName,
        image: event.image,
        submission: Submission.hasData));
    // });
  }

  _onSearchForEmployeeEvent(
      SearchForEmployeeEvent event, Emitter<SearchByImageState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .searchForpersonByImage(
      companyName: state.companyName,
      // imageName:state.imageName,
      // image: state.files,
      image: state.image,
    )
        .then((value) {
      // if (state.cameraSelectedModels.isNotEmpty) {
      //   add(const ApplyModelEvent());
      // }
      if (value != ()) {
        emit(SearchByImageState().copyWith(submission: Submission.success));
      } else {
        emit(state.copyWith(submission: Submission.error));
      }
    });
  }
}
