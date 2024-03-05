import 'package:Investigator/presentation/signup/screens/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/authentication_repository.dart';
import '../../../core/resources/app_colors.dart';
import '../cubit/signup_cubit.dart';

class SignUpPage extends StatelessWidget {
   static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => SignUpPage(),
    );
  }
  
  const SignUpPage({super.key});

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
        create: (_) => SignupCubit(context.read<AuthenticationRepository>()),
        child: const SignUpForm(),
      ),
    );
  }
}

