part of 'search_by_image_bloc.dart';

class SearchByImageState extends Equatable {
  final String companyName;
  final String image;
  final Submission submission;

  const SearchByImageState({
    this.submission = Submission.initial,
    this.companyName = "",
    this.image = "",
  });

  SearchByImageState copyWith({
    String? companyName,
    String? image,
    Submission? submission,
  }) {
    return SearchByImageState(
      companyName: companyName ?? this.companyName,
      image: image ?? this.image,
      submission: submission ?? this.submission,
    );
  }

  @override
  List<Object> get props => [
        companyName,
        image,
        submission,
      ];
}
