import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_supabase/bloc/password_bloc/forgot_password_bloc.dart';
import 'package:todo_supabase/bloc/password_bloc/reset_password_bloc.dart';
import 'package:todo_supabase/pages/wrapper/login_page.dart';
import 'package:todo_supabase/bloc/auth_bloc/auth_bloc.dart';
import 'package:todo_supabase/bloc/auth_bloc/auth_event.dart';
import 'package:todo_supabase/bloc/auth_bloc/auth_state.dart';
import 'package:todo_supabase/pages/wrapper/home_page.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;
  const AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(AuthCheck())),
        BlocProvider(create: (_) => ForgotPasswordBloc()),
        BlocProvider(create: (_) => ResetPasswordBloc()),
      ],
      child: child,
    );
  }
}

class AuthWrapperView extends StatelessWidget {
  const AuthWrapperView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.failure) {
          showDialog(
            context: context,
            builder:
                (context) => const AlertDialog(
                  title: Text('Error'),
                  content: Text('Failed to authenticate'),
                ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isAuthenticated &&
              state.status == AuthStatus.success) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
