part of 'search_by_image_bloc.dart';

class SearchByImageState extends Equatable {
  List<List<double>>? boxes;
  List<String>? result;
  final Widget? imageWidget;

  final String companyName;
  final String image;
  final Submission submission;

  SearchByImageState({
    this.imageWidget,
    this.result,
    this.boxes,
    this.submission = Submission.initial,
    this.companyName = "",
    this.image = "",
  });

  SearchByImageState copyWith({
    List<List<double>>? boxes,
    Widget? imageWidget,
    List<String>? result,
    String? companyName,
    String? image,
    Submission? submission,
  }) {
    return SearchByImageState(
      result: result ?? this.result,
      boxes: boxes ?? this.boxes,
      imageWidget: imageWidget ?? this.imageWidget,
      companyName: companyName ?? this.companyName,
      image: image ?? this.image,
      submission: submission ?? this.submission,
    );
  }

  @override
  List<Object?> get props => [
        imageWidget,
        result,
        boxes,
        companyName,
        image,
        submission,
      ];
}
