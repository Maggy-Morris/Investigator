import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum PasswordValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template password}

/// Form input for an password input.

/// {@endtemplate}
class Password extends FormzInput<String, PasswordValidationError> {
  /// {@macro password}
  const Password.pure() : super.pure('');

  /// {@macro password}
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return PasswordValidationError.invalid;
    }
    return null;

    // return _passwordRegExp.hasMatch(value ?? '')
    //     ? null
    //     : PasswordValidationError.invalid;

    // return null;
  }
}





// import 'package:formz/formz.dart';

// /// Validation errors for the [Password] [FormzInput].
// enum PasswordValidationError {
//   /// Generic invalid error.
//   invalid
// }

// /// Form input for a password input.
// class Password extends FormzInput<String, PasswordValidationError> {
//   /// Constructs a pure instance of [Password].
//   const Password.pure() : super.pure('');

//   /// Constructs a dirty instance of [Password].
//   const Password.dirty([String value = '']) : super.dirty(value);

//   @override
//   PasswordValidationError? validator(String? value) {
//     return _passwordRegExp.hasMatch(value ?? '')
//         ? null
//         : PasswordValidationError.invalid;
//   }
// }

// final _passwordRegExp = RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{8,}$');

