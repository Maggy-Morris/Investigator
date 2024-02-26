part of 'dashboard_bloc.dart';

class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardMainDataEvent extends DashboardEvent {
  const DashboardMainDataEvent();

  @override
  List<Object?> get props => [];
}
class DashboardInitializeDate extends DashboardEvent {
  const DashboardInitializeDate();

  @override
  List<Object?> get props => [];
}

class DashboardGetAllCamerasCounts extends DashboardEvent {
  const DashboardGetAllCamerasCounts();

  @override
  List<Object?> get props => [];
}
class DashboardGetAllCamerasStatistics extends DashboardEvent {
  const DashboardGetAllCamerasStatistics();

  @override
  List<Object?> get props => [];
}

class DashboardAddDay extends DashboardEvent {
  final String selectedDay;

  const DashboardAddDay({required this.selectedDay});

  @override
  List<Object?> get props => [selectedDay];
}

class DashboardAddMonth extends DashboardEvent {
  final String selectedMonth;

  const DashboardAddMonth({required this.selectedMonth});

  @override
  List<Object?> get props => [selectedMonth];
}

class DashboardAddYear extends DashboardEvent {
  final String selectedYear;

  const DashboardAddYear({required this.selectedYear});

  @override
  List<Object?> get props => [selectedYear];
}
