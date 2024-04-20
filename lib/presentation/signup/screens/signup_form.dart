import 'package:Investigator/presentation/login/view/login_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:Investigator/core/loader/loading_indicator.dart';
import 'package:Investigator/core/resources/app_fonts.dart';
import 'package:Investigator/core/utils/responsive.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/presentation/login/widgets/custom_text.dart';
// import 'package:svg_flutter/svg.dart';

import '../../../core/resources/app_colors.dart';
import '../../all_employees/screens/all_employees.dart';
import '../cubit/signup_cubit.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
      },
      child: Stack(
        children: [
          SelectionArea(
            child: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Image.asset(
                  //   "assets/images/bbb.jpeg",
                  //   height: MediaQuery.of(context).size.height,
                  //   width: MediaQuery.of(context).size.width,
                  //   fit: BoxFit.cover,
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            FxBox.h20,
                            Center(
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 660,
                                ),
                                padding: Responsive.isMobile(context)
                                    ? const EdgeInsets.all(32)
                                    : const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  color: AppColors.grey5,
                                  border: Border.all(
                                    color: AppColors.white.withOpacity(0.9),
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 80, child: _logoView()),
                                    // FxBox.h16,
                                    _bottomView(),
                                  ],
                                ),
                              ),
                            ),
                            // FxBox.h20,
                          ],
                        ),
                      ),
                      // Responsive.isWeb(context)
                      //     ? Expanded(
                      //         child: Column(
                      //           children: [
                      //             // Container(
                      //             //   constraints:
                      //             //       const BoxConstraints(maxHeight: 400),
                      //             //   child: SvgPicture.asset(
                      //             //     "assets/images/Admin_Kit_Text.svg",
                      //             //   ),
                      //             // ),
                      //             FxBox.h16,
                      //           ],
                      //         ),
                      //       )
                      //     : Container(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _logoView() {
  return Image.asset(
    "assets/images/ico.png",
  );
  // SvgPicture.asset("assets/images/Admin_Kit.svg");
}

Widget _bottomView() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    //mainAxisSize: MainAxisSize.min,
    children: [
      FxBox.h16,
      headerView("Sign Up".tr(), "", true),
      FxBox.h28,
      Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Email".tr(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Cairo",
                        fontSize: AppFontSize.s14,
                        fontWeight: FontWeight.bold)),
              ),
              FxBox.h8,
              _EmailInput(),
            ],
          ),
          const SizedBox(
            width: 25,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "password".tr(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Cairo",
                      fontSize: AppFontSize.s14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              FxBox.h8,
              _PasswordInput(),
            ],
          ),
        ],
      ),
      FxBox.h8,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Company Name".tr(),
            style: const TextStyle(
                color: Colors.white,
                fontFamily: "Cairo",
                fontSize: AppFontSize.s14,
                fontWeight: FontWeight.bold)),
      ),
      companyNameInput(),
      FxBox.h20,
      const DropDwon(),
      FxBox.h28,
      Center(child: _SignUpButton()),
      FxBox.h28,
    ],
  );
}

class DropDwon extends StatelessWidget {
  const DropDwon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  const Text(
                    "Choose Number Of Rooms :",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  SizedBox(
                    width: 35,
                  ),
                  DropdownButton<int>(
                    value: state.selectedNumber,
                    onChanged: (value) {
                      context
                          .read<SignupCubit>()
                          .selectedNumberChanged(value ?? 0);
                    },
                    items: List.generate(101, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(
                          '${index}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 20),
              state.selectedNumber! > 0
                  ? Column(
                      children: List.generate(
                        (state.selectedNumber! / 2)
                            .ceil(), // Adjust the number of rows
                        (rowIndex) {
                          return Row(
                            children: List.generate(
                              2, // Two text fields per row
                              (colIndex) {
                                final roomIndex = rowIndex * 2 + colIndex;
                                if (roomIndex < state.selectedNumber!) {
                                  return SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 15.0, right: 25.0),
                                      child: TextField(
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          labelText:
                                              'Room Number ${roomIndex + 1}',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  style: BorderStyle.none)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  style: BorderStyle.none)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  style: BorderStyle.none)),
                                          filled: true,
                                          fillColor: AppColors.primaryColorDark,
                                          isDense: true,
                                        ),
                                        onChanged: (value) {
                                          context
                                              .read<SignupCubit>()
                                              .roomNumbersChanged(
                                                  roomIndex, value);
                                        },
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          4);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 5,
          child: TextFormField(
            style: TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<SignupCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              // hintStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(style: BorderStyle.none)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(style: BorderStyle.none)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(style: BorderStyle.none)),
              filled: true,
              fillColor: AppColors.primaryColorDark,
              isDense: true,
              // labelText: 'Email',
              hintText: 'enterUserName'.tr(),
              errorText: state.email.invalid ? 'wrongUserName'.tr() : null,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatefulWidget {
  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class companyNameInput extends StatefulWidget {
  @override
  State<companyNameInput> createState() => _companyNameInputState();
}

class _companyNameInputState extends State<companyNameInput> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      // buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            style: TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            // key: const Key('loginForm_emailInput_textField'),
            onChanged: (companyName) =>
                context.read<SignupCubit>().companyNameChanged(companyName),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              // hintStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(style: BorderStyle.none)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(style: BorderStyle.none)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(style: BorderStyle.none)),
              filled: true,
              fillColor: AppColors.primaryColorDark,
              isDense: true,
              // labelText: 'Email',
              hintText: 'Enter Company Name'.tr(),
              // errorText: state.email.invalid ? 'wrongUserName'.tr() : null,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInputState extends State<_PasswordInput> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 5,
          child: TextField(
            style: TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            obscureText: visible,
            obscuringCharacter: "•",
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<SignupCubit>().passwordChanged(password),
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(
                  visible ? Icons.remove_red_eye : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    visible = !visible;
                  });
                },
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(style: BorderStyle.none)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(style: BorderStyle.none)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(style: BorderStyle.none)),
              filled: true,
              fillColor: AppColors.primaryColorDark,
              isDense: true,
              // labelText: 'Password',
              hintText: 'enterPassword'.tr(),
              errorText: state.password.invalid ? 'wrongPassword'.tr() : null,
            ),
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? loadingIndicator(
                color: Theme.of(context).primaryColor,
              )
            : SizedBox(
                width: Responsive.isWeb(context)
                    ? MediaQuery.of(context).size.width * 0.20
                    : MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  key: const Key('signUpForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: state.status.isValidated
                      ? () {
                          //check this one out
                          context.read<SignupCubit>().signUpWithCredentials();
                          state.status.isValidated
                              ? Navigator.pop(context)

                              // Navigator.of(context).push(
                              //     MaterialPageRoute<void>(
                              //         builder: (_) => const LoginPage()))
                              : null;
                        }
                      : null,
                  child: Text('Sign Up'.tr(),
                      style: const TextStyle(
                          fontFamily: "Cairo", color: Colors.white)),
                ),
              );
      },
    );
  }
}
