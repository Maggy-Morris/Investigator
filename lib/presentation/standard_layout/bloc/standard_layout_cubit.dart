import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'standard_layout_state.dart';

class StandardLayoutCubit extends Cubit<StandardLayoutState> {
  static StandardLayoutCubit get(context) => BlocProvider.of<StandardLayoutCubit>(context);
  StandardLayoutCubit() : super(StandardLayoutState());

  onEditExtend(bool extend) {
    emit(state.copyWith(
      extend: extend,
      selectedPage: state.selectedPage,
    ));
  }

  onEditPageNavigationNumber(int navigationPage) {
    emit(state.copyWith(
      selectedPage: navigationPage,
    ));
  }

}
