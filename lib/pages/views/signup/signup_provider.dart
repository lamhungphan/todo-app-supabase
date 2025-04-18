import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_supabase/bloc/signup_bloc/signup_bloc.dart';
import 'package:todo_supabase/pages/views/signup/signup_view.dart';

class SignupProvider extends StatelessWidget {
  const SignupProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupBloc(),
      child: const SignupView(),
    );
  }
}
