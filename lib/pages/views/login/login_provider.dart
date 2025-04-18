import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_supabase/bloc/login_bloc/login_bloc.dart';
import 'package:todo_supabase/pages/views/login/login_view.dart';

class LoginProvider extends StatelessWidget {
  const LoginProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: LoginScreenView.LoginView(),
    );
  }
}
