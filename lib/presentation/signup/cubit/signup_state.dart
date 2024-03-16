part of 'signup_cubit.dart';

class SignupState extends Equatable {
  const SignupState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.companyName = "",
  });

  final Email email;
  final Password password;
  final FormzStatus status;
  final String? errorMessage;
  final String? companyName;

  @override
  List<Object?> get props => [email, password, status, companyName];

  SignupState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    String? errorMessage,
    String? companyName,
  }) {
    return SignupState(
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
