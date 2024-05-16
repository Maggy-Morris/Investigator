part of 'history_bloc.dart';

class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class SecondsGivenFromVideoEvent extends HistoryEvent {
  final int secondsGivenFromVideo;

  const SecondsGivenFromVideoEvent({required this.secondsGivenFromVideo});

  @override
  List<Object> get props => [secondsGivenFromVideo];
}

class EditvideoPathForHistory extends HistoryEvent {
  final String videoPathForHistory;

  const EditvideoPathForHistory({required this.videoPathForHistory});

  @override
  List<Object> get props => [videoPathForHistory];
}

class EditPathProvided extends HistoryEvent {
  final String pathProvided;

  const EditPathProvided({required this.pathProvided});

  @override
  List<Object> get props => [pathProvided];
}

class EditPageCount extends HistoryEvent {
  final int pageCount;

  const EditPageCount({required this.pageCount});

  @override
  List<Object> get props => [pageCount];
}

class EditPageNumberInsideHistoryDetails extends HistoryEvent {
  final int pageIndex;

  const EditPageNumberInsideHistoryDetails({required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}

class EditPageNumber extends HistoryEvent {
  final int pageIndex;

  const EditPageNumber({required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}

class EditPageNumberFiltered extends HistoryEvent {
  final int pageIndex;

  const EditPageNumberFiltered({required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}

class PathesDataEvent extends HistoryEvent {
  const PathesDataEvent();

  @override
  List<Object?> get props => [];
}

class SearchByDay extends HistoryEvent {
  final String selectedDay;

  const SearchByDay({required this.selectedDay});

  @override
  List<Object?> get props => [selectedDay];
}

class SearchByMonth extends HistoryEvent {
  final String selectedMonth;

  const SearchByMonth({required this.selectedMonth});

  @override
  List<Object?> get props => [selectedMonth];
}

class SearchByYear extends HistoryEvent {
  final String selectedYear;

  const SearchByYear({required this.selectedYear});

  @override
  List<Object?> get props => [selectedYear];
}

class FilterSearchDataEvent extends HistoryEvent {
  const FilterSearchDataEvent();

  @override
  List<Object?> get props => [];
}


// class VideoStreamChanged extends HistoryEvent {
//   final Uint8List videoStream;
//   const VideoStreamChanged({required this.videoStream});

//   @override
//   List<Object?> get props => [videoStream];
// }

// class CameraInitializeDate extends HistoryEvent {
//   const CameraInitializeDate();

//   @override
//   List<Object?> get props => [];
// }

// class CameraDetailsEvent extends HistoryEvent {
//   final String cameraName;

//   const CameraDetailsEvent({required this.cameraName});

//   @override
//   List<Object?> get props => [cameraName];
// }

// class GetModelsChartsData extends HistoryEvent {
//   final List<String> modelsList;
//   final String cameraName;

//   const GetModelsChartsData(
//       {required this.modelsList, required this.cameraName});

//   @override
//   List<Object?> get props => [modelsList, cameraName];



  
// }
