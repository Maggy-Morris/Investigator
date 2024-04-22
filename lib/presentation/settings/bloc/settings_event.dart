part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class UpdateRooms extends SettingsEvent {
  // final String passwordUpdate;

  const UpdateRooms();

  @override
  List<Object> get props => [];
}

class UpdateRoomsEvent extends SettingsEvent {
  final String? roomNames;
  final int index;

  const UpdateRoomsEvent({this.roomNames, required this.index});

  @override
  List<Object?> get props => [roomNames, index];
}

class InitialList extends SettingsEvent {
  final List<String> list;

  const InitialList({required this.list});

  @override
  List<Object> get props => [list];
}

class AddListItem extends SettingsEvent {
  const AddListItem();

  @override
  List<Object> get props => [];
}

class UpdatePasswordEvent extends SettingsEvent {
  final String passwordUpd;

  const UpdatePasswordEvent({required this.passwordUpd});

  @override
  List<Object> get props => [passwordUpd];
}

class oldPasswordEvent extends SettingsEvent {
  final String oldpassword;

  const oldPasswordEvent({required this.oldpassword});

  @override
  List<Object> get props => [oldpassword];
}


class UpdatePassword extends SettingsEvent {
  // final String passwordUpdate;

  const UpdatePassword();

  @override
  List<Object> get props => [];
}
