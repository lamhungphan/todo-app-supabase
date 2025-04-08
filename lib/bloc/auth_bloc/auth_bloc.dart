import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_supabase/bloc/auth_bloc/auth_event.dart';
import 'package:todo_supabase/bloc/auth_bloc/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
    : super(AuthState(isAuthenticated: false, status: AuthStatus.initial)) {
    on<AuthCheck>(_onAuthCheck);
  }

  void _onAuthCheck(AuthCheck event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final supabase = sp.Supabase.instance.client;
    final user = supabase.auth.currentSession?.user;

    if (user != null) {
      emit(state.copyWith(status: AuthStatus.success, isAuthenticated: true));
    } else {
      emit(state.copyWith(status: AuthStatus.initial, isAuthenticated: false));
    }
  }
}
