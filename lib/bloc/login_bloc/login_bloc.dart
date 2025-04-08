import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_supabase/bloc/login_bloc/login_event.dart';
import 'package:todo_supabase/bloc/login_bloc/login_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState(status: LoginStatus.init)) {
    on<Login>(_onSignin);
  }

  void _onSignin(Login event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));
    final supabase = sp.Supabase.instance.client;

    try {
      final response = await supabase.auth.signInWithPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      if (response.user != null) {
        emit(state.copyWith(status: LoginStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }
}
