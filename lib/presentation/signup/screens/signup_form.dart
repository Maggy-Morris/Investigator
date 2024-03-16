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
                  Image.asset(
                    "assets/images/bbb.jpeg",
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FxBox.h20,
                            Center(
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 460,
                                ),
                                padding: Responsive.isMobile(context)
                                    ? const EdgeInsets.all(32)
                                    : const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  color: AppColors.blueB.withOpacity(0.9),
                                  border: Border.all(
                                    color: AppColors.blueB.withOpacity(0.9),
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
                      // ? Expanded(
                      //     child: Column(
                      //       children: [
                      //         Container(
                      //           constraints:
                      //               const BoxConstraints(maxHeight: 400),
                      //           child: SvgPicture.asset(
                      //             "assets/images/Admin_Kit_Text.svg",
                      //           ),
                      //         ),
                      //         FxBox.h16,
                      //       ],
                      //     ),
                      //   )
                      // : Container(),
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
      headerView("Sign Up".tr(), "", false),
      FxBox.h28,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("userName".tr(),
            style: const TextStyle(
                fontFamily: "Cairo",
                fontSize: AppFontSize.s14,
                fontWeight: FontWeight.bold)),
      ),
      // FxBox.h8,
      _EmailInput(),
      FxBox.h8,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "password".tr(),
          style: const TextStyle(
              fontFamily: "Cairo",
              fontSize: AppFontSize.s14,
              fontWeight: FontWeight.bold),
        ),
      ),
      // FxBox.h8,
      _PasswordInput(),
      FxBox.h8,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Company Name".tr(),
            style: const TextStyle(
                fontFamily: "Cairo",
                fontSize: AppFontSize.s14,
                fontWeight: FontWeight.bold)),
      ),
      companyNameInput(),
      FxBox.h28,
      Center(child: _SignUpButton()),
      FxBox.h20,
    ],
  );
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
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
          width: MediaQuery.of(context).size.width,
          child: TextField(
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
                color: AppColors.blueBlack,
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
                    backgroundColor: const Color(0xff1c1c1a),
                  ),
                  onPressed: state.status.isValidated
                      ? () {
                          context.read<SignupCubit>().signUpWithCredentials();
                         
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
