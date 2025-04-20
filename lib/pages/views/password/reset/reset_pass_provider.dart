import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_supabase/bloc/password_bloc/reset_pass_bloc.dart';
import 'package:todo_supabase/pages/views/password/reset/reset_pass_view.dart';

class ResetPassProvider extends StatelessWidget {
  const ResetPassProvider({super.key, required String token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(),
      child: ResetPassView(token: '',),
    );
  }
}