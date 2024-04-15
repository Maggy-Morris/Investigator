import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:Investigator/presentation/login/widgets/password.dart';

import '../../../authentication/authentication_repository.dart';
import '../../login/widgets/email.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this._authenticationRepository) : super(SignupState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([email, state.password]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([state.email, password]),
      ),
    );
  }

  void companyNameChanged(String value) {
    emit(
      state.copyWith(
        companyName: value,
      ),
    );
  }

  void selectedNumberChanged(int value) {
    emit(
      state.copyWith(
        selectedNumber: value,
      ),
    );
  }

  // void roomNumbersChanged(List<String> value) {
  //   emit(
  //     state.copyWith(
  //       roomNumbers: value,
  //     ),
  //   );
  // }
  void roomNumbersChanged(int index, String value) {
    List<String> updatedRoomNumbers = List.from(state.roomNames);

    // Ensure the list has enough elements to access the specified index
    while (updatedRoomNumbers.length <= index) {
      updatedRoomNumbers.add('');
    }

    updatedRoomNumbers[index] = value;

    emit(
      state.copyWith(
        roomNames: updatedRoomNumbers,
      ),
    );
  }

  Future<void> signUpWithCredentials() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.SignUpWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
        companyName: state.companyName ?? "",
        roomNames: state.roomNames,
        roomsNumber: state.selectedNumber ?? 0,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on SignUpWithEmailAndPasswordFailureFirebase catch (e) {
      emit(
        state.copyWith(
          errorMessage: "E-mail is already  in use",
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
