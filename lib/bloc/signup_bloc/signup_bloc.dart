import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;
import 'package:todo_supabase/bloc/signup_bloc/signup_event.dart';
import 'package:todo_supabase/bloc/signup_bloc/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupState(status: SignupStatus.init)) {
    on<Signup>(_onSignup);
  }

  void _onSignup(Signup event, Emitter<SignupState> emit) async {
    emit(state.copyWith(status: SignupStatus.loading));

    if (event.password.trim() != event.confirmPassword.trim()) {
      emit(state.copyWith(status: SignupStatus.failure));
      return;
    }
    
    final supabase = sp.Supabase.instance.client;

    try {
      final response = await supabase.auth.signUp(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      if (response.user != null) {
        emit(state.copyWith(status: SignupStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(status: SignupStatus.failure));
    }
  }
}
