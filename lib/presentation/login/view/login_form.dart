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
import '../../signup/screens/signup_screen.dart';
import '../cubit/login_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
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
                          // mainAxisSize: MainAxisSize.min,
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
                                  color: AppColors.blueB,
                                  border: Border.all(
                                    color: AppColors.blueB,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 80, child: _logoView()),
                                    // Image.asset("assets/images/logo.png"),
                                    FxBox.h16,
                                    // ConstantAuth.headerView(
                                    //   languageModel.authentication.signIn,
                                    //   languageModel.authentication.signInText,
                                    //   context,
                                    // ),
                                    _bottomView(),
                                  ],
                                ),
                              ),
                            ),
                            FxBox.h20,
                          ],
                        ),
                      ),
                      Responsive.isWeb(context)
                          ? Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxHeight: 400),
                                    child: Image.asset(
                                      "assets/images/Detective.png",
                                    ),
                                    //     SvgPicture.asset(
                                    //   "assets/images/A.svg",
                                    // ),
                                  ),
                                  FxBox.h16,
                                  // Center(
                                  //   child: CustomText(
                                  //     title: languageModel.authentication.signInHeader,
                                  //     fontSize: 15,
                                  //     fontWeight: FontWeight.w700,
                                  //     textColor: ColorConst.lightFontColor,
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // child: Align(
      //   alignment: const Alignment(0, -1 / 3),
      //   child: Container(
      //     padding: const EdgeInsets.all(50),
      //     decoration: BoxDecoration(
      //         color: Colors.white38.withOpacity(0.3),
      //         borderRadius: BorderRadius.circular(15)),
      //     child: SingleChildScrollView(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           Image.asset(
      //             'assets/images/logo.png',
      //             height: 160,
      //             width: 263,
      //           ),
      //           _EmailInput(),
      //           const SizedBox(height: 20),
      //           _PasswordInput(),
      //           const SizedBox(height: 30),
      //           _LoginButton(),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
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
      headerView("login".tr(), "", false),
      FxBox.h28,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("userName".tr(),
            style: const TextStyle(
                fontFamily: "Cairo",
                fontSize: AppFontSize.s14,
                fontWeight: FontWeight.bold)),
      ),
      FxBox.h8,
      _EmailInput(),
      FxBox.h16,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("password".tr(),
            style: const TextStyle(
                fontFamily: "Cairo",
                fontSize: AppFontSize.s14,
                fontWeight: FontWeight.bold)),
      ),
      FxBox.h8,
      _PasswordInput(),
      FxBox.h28,
      Center(child: _LoginButton()),
      FxBox.h20,
      Center(child: _SignUpButton()),

      FxBox.h20,
      // _serviceText(),
    ],
  );
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            cursorColor: Colors.black,
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<LoginCubit>().emailChanged(email),
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

class _PasswordInputState extends State<_PasswordInput> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
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
                context.read<LoginCubit>().passwordChanged(password),
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

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
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
                  key: const Key('loginForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: const Color(0xff1c1c1a),
                  ),
                  onPressed: state.status.isValidated
                      ? () => context.read<LoginCubit>().logInWithCredentials()
                      : null,
                  child: Text('login'.tr(),
                      style: const TextStyle(
                          fontFamily: "Cairo", color: Colors.white)),
                ),
              );
      },
    );
  }
}

// class _GoogleLoginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return ElevatedButton.icon(
//       key: const Key('loginForm_googleLogin_raisedButton'),
//       label: const Text(
//         'SIGN IN WITH GOOGLE',
//         style: TextStyle(color: Colors.white),
//       ),
//       style: ElevatedButton.styleFrom(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         backgroundColor: theme.colorScheme.secondary,
//       ),
//       icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
//       onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
//     );
//   }
// }

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      onPressed: () {
        Navigator.of(context).push<void>(SignUpPage.route());
      },
      child: Text(
        'CREATE ACCOUNT',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
