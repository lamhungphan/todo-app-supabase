
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_supabase/bloc/password_bloc/reset_pass_bloc.dart';
import 'package:todo_supabase/pages/views/password/verify/verify_pass_view.dart';

class VeriryPassProvider extends StatelessWidget {
  const VeriryPassProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(),
      child: VerifyPassView(),
    );
  }
}