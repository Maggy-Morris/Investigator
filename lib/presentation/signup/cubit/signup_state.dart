part of 'signup_cubit.dart';

class SignupState extends Equatable {
   SignupState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.companyName = "",
    this.selectedNumber = 0,
    this.roomNames = const[],
  });
  final int? selectedNumber;
   List<String> roomNames;
  final Email email;
  final Password password;
  final FormzStatus status;
  final String? errorMessage;
  final String? companyName;

  @override
  List<Object?> get props =>
      [roomNames,selectedNumber, email, password, status, companyName];

  SignupState copyWith({
    List<String>? roomNames,
    int? selectedNumber,
    Email? email,
    Password? password,
    FormzStatus? status,
    String? errorMessage,
    String? companyName,
  }) {
    return SignupState(
      roomNames : roomNames ?? this.roomNames,
      selectedNumber: selectedNumber ?? this.selectedNumber,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
