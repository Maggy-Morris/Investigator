part of 'standard_layout_cubit.dart';

class StandardLayoutState extends Equatable {
  final int selectedPage;
  final bool extend;

  const StandardLayoutState({
    this.extend = true,
    this.selectedPage = 0,
  });

  StandardLayoutState copyWith({
    int? selectedPage,
    bool? extend,
  }) {
    return StandardLayoutState(
      extend: extend ?? this.extend,
      selectedPage: selectedPage ?? this.selectedPage,
    );
  }


  @override
  List<Object> get props =>
      [
        extend,
        selectedPage,
      ];
}
