import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_supabase/bloc/password_bloc/reset_password_event.dart';
import 'package:todo_supabase/bloc/password_bloc/reset_password_state.dart';
import 'dart:async';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(ResetPasswordState()) {
    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<TokenReceived>((event, emit) {
      emit(state.copyWith(token: event.token));
    });

    on<SubmitNewPassword>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitNewPassword event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetStatus.loading));

    try {
      final supabase = Supabase.instance.client;
      
      // Set session để xác thực qua token
      await supabase.auth.setSession(state.token);

      // Gọi API reset password
      await supabase.auth.updateUser(UserAttributes(password: state.password));

      emit(state.copyWith(status: ResetStatus.success));
    } catch (e) {
      print('Reset failed: $e');
      emit(state.copyWith(status: ResetStatus.failure));
    }
  }
}
