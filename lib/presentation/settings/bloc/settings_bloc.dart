import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/authentication_repository.dart';
import '../../../core/enum/enum.dart';
import '../../../core/models/employee_model.dart';
import '../../../core/remote_provider/remote_provider.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  String companyNameRepo =
      AuthenticationRepository.instance.currentUser.companyName?.first ?? "";
  static SettingsBloc get(context) => BlocProvider.of<SettingsBloc>(context);

  SettingsBloc() : super(SettingsState()) {
    on<SettingsEvent>((event, emit) {});
    on<UpdateRoomsEvent>(_onUpdateRoomsEvent);
    on<UpdateRoomsEventToList>(_onUpdateRoomsEventToList);

    on<UpdateRooms>(_onUpdateRooms);
    on<InitialList>(_onInitialList);
    on<AddListItem>(_onAddListItem);

    on<oldPasswordEvent>(_onoldPasswordEvent);

    on<UpdatePasswordEvent>(_onUpdatePasswordEvent);
    on<UpdatePassword>(_onUpdatePassword);
  }

  _onoldPasswordEvent(
      oldPasswordEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(
      oldpassword: event.oldpassword,
      submission: Submission.hasData,
    ));
  }

  _onUpdatePasswordEvent(
      UpdatePasswordEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(
      passwordUpdate: event.passwordUpd,
      submission: Submission.hasData,
    ));
  }

  _onUpdatePassword(UpdatePassword event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    try {
      final result = await RemoteProvider().UpdatePassword(
        email: AuthenticationRepository.instance.currentUser.username ?? "",
        password: state.passwordUpdate,
        oldPassword: state.oldpassword,
      );
      if (result.updated == true) {
        emit(state.copyWith(
          submission: Submission.success,
          responseMessage: result.data,
        ));
      } else if (result.updated == false) {
        emit(state.copyWith(
          submission: Submission.error,
          responseMessage: result.data,
        ));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(submission: Submission.error));
    }
  }

  _onUpdateRoomsEvent(
      UpdateRoomsEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(
      rooms: event.rooms,
      submission: Submission.hasData,
    ));
  }

  _onUpdateRoomsEventToList(
      UpdateRoomsEventToList event, Emitter<SettingsState> emit) async {
    List<String> newList = state.roomNAMS;
    if (event.roomNames != null) {
      if (event.roomNames?.isNotEmpty ?? false) {
        newList[event.index] = event.roomNames ?? "";

        emit(state.copyWith(
          roomNAMS: newList,
          ////////////////////////////////////
          // roomNames: state.roomNames,
          // room_numbers: event.room_num,
          // submission: Submission.hasData,
        ));
      }
    } else {
      newList.removeAt(event.index);
      emit(state.copyWith(
        roomNAMS: newList,
      ));
    }
  }

  _onInitialList(InitialList event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(
      roomNAMS: event.list,
      // room_numbers: event.room_num,
      // submission: Submission.hasData,
    ));
  }

  _onAddListItem(AddListItem event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(
        roomNAMS: [...state.roomNAMS, ""],
        submission: Submission.success,
        responseMessage:
            "A Slot is Added Scroll down if you can't see it and enter the name of your room the press Add"
        // room_numbers: event.room_num,
        ));
  }

  _onUpdateRooms(UpdateRooms event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(submission: Submission.loading));
    try {
      final result = await RemoteProvider().UpdateRooms(
        // companyName: event.companyName,
        // personName: state.personName,
        // phoneNum: state.phoneNum,
        email: AuthenticationRepository.instance.currentUser.username ?? "",
        roomsNumber: state.roomNAMS.length,
        roomNames: state.roomNAMS,
      );
      // result.updated == true
      if (result.updated == true) {
        emit(state.copyWith(
          submission: Submission.success,
          responseMessage: "Rooms Updated Successfully",

          // employeeNamesList:
        ));
        await AuthenticationRepository.instance
            .updateRoomsNames(state.roomNAMS);
        // await AuthenticationRepository.getInstance();
      } else {
        emit(state.copyWith(submission: Submission.noDataFound));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(submission: Submission.error));
    }
  }
}
