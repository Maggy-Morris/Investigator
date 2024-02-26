import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Investigator/core/resources/app_colors.dart';
import '../../../authentication/authentication_repository.dart';
import '../cubit/login_cubit.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            AppColors.blue.withOpacity(0.3),
            AppColors.blue.withOpacity(0.5),
            AppColors.blue.withOpacity(0.3),
            // Colors.white24,
            // Colors.blueGrey.withOpacity(0.5),
            // Colors.blueGrey.withOpacity(0.6),
            // Colors.white24,
          ])),
      child: BlocProvider(
        create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
        child: const LoginForm(),
      ),
    );
  }
}
