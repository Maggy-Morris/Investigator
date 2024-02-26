part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final List<String> allCameras;
  final List<GetAllCameraCount> camerasCounts;
  final List<List<GetAllCameraCountPerHour>> camerasCountsPerHour;
  final String selectedDay;
  final String selectedMonth;
  final String selectedYear;

  const DashboardState({
    this.camerasCounts = const [],
    this.allCameras = const [],
    this.camerasCountsPerHour = const [],
    this.selectedDay = "",
    this.selectedMonth = "",
    this.selectedYear = "",
  });

  DashboardState copyWith({
    List<String>? allCameras,
    List<GetAllCameraCount>? camerasCounts,
    List<List<GetAllCameraCountPerHour>>? camerasCountsPerHour,
    String? selectedDay,
    String? selectedMonth,
    String? selectedYear,
  }) {
    return DashboardState(
      allCameras: allCameras ?? this.allCameras,
      camerasCounts: camerasCounts ?? this.camerasCounts,
      camerasCountsPerHour: camerasCountsPerHour ?? this.camerasCountsPerHour,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }

  @override
  List<Object> get props => [
        selectedDay,
        selectedMonth,
        selectedYear,
        allCameras,
        camerasCounts,
        camerasCountsPerHour,
      ];
}
