import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_supabase/bloc/password_bloc/forgot_password_bloc.dart';
import 'package:todo_supabase/pages/views/password_forgot/forgot_pass_view.dart';

class ForgotPassProvider extends StatelessWidget {
  const ForgotPassProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordBloc(),
      child: Builder(
        builder: (context) {
          return const ForgotPassView();
        },
      ),
    );
  }
}
