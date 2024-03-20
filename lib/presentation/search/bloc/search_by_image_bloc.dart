import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/enum.dart';
import '../../../core/loader/loading_indicator.dart';
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
    on<ImageToSearchForEmployee>(_onImageToSearchForEmployee);
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

  _onImageToSearchForEmployee(
      ImageToSearchForEmployee event, Emitter<SearchByImageState> emit) async {
    emit(state.copyWith(
        imageWidget: event.imageWidget, submission: Submission.loading));
    // Your logic here to fetch data and determine the imageWidget
  }

  _onSearchForEmployeeEvent(
      SearchForEmployeeEvent event, Emitter<SearchByImageState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    await RemoteProvider()
        .searchForpersonByImage(
      companyName: state.companyName,
      image: state.image,
    )
        .then((value) {
      if (value.targeted == true) {
        emit(
          SearchByImageState().copyWith(
            submission: Submission.success,
            boxes: value.boxes,
            result: value.result,
          ),
        );
      } else {
        emit(state.copyWith(submission: Submission.noDataFound));
      }
    });
  }
}
