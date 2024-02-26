part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState({
    required this.status,
    this.user = UserData.empty,
  });

  const AppState.unauthenticated() : this(status: AppStatus.unauthenticated);

  AppState copyWith({
    AppStatus? status,
    UserData? user,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  final AppStatus status;
  final UserData? user;

  @override
  List<Object?> get props => [status, user];
}
