import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_supabase/pages/views/login/login_provider.dart';
import 'package:todo_supabase/bloc/auth_bloc/auth_bloc.dart';
import 'package:todo_supabase/bloc/auth_bloc/auth_event.dart';
import 'package:todo_supabase/bloc/auth_bloc/auth_state.dart';
import 'package:todo_supabase/pages/views/todo/todo_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc()..add(AuthCheck()),
      child: const AuthWrapperView(),
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
            return const TodoProvider();
          } else {
            return const LoginProvider();
          }
        },
      ),
    );
  }
}
