import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;
import 'package:todo_supabase/bloc/signup_bloc/signup_event.dart';
import 'package:todo_supabase/bloc/signup_bloc/signup_state.dart';

// separation of concerns
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupState(status: SignupStatus.init)) {
    on<SignupEventSubmitted>(_onSignup);
  }

  void _onSignup(SignupEventSubmitted event, Emitter<SignupState> emit) async {
    emit(state.copyWith(status: SignupStatus.loading, error: ''));

    try {
      final res = await sp.Supabase.instance.client.auth.signUp(
        email: event.email,
        password: event.password,
      );

      if (res.user != null) {
        emit(state.copyWith(status: SignupStatus.success, error: ''));
      } else {
        emit(
          state.copyWith(status: SignupStatus.failure, error: 'Unknown error'),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: SignupStatus.failure, error: e.toString()));
    }
  }
}
