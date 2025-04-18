import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_supabase/bloc/password_bloc/forgot_password_event.dart';
import 'package:todo_supabase/bloc/password_bloc/forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, PasswordState> {
  ForgotPasswordBloc() : super(PasswordState(status: PasswordStatus.init)) {
    on<ForgotPasswordEmailChanged>(_onEmailChanged);
    on<ForgotPasswordSubmitted>(_onSubmitForgotPassword);
  }

  void _onEmailChanged(
    ForgotPasswordEmailChanged event,
    Emitter<PasswordState> emit,
  ) {
    emit(state.copyWith(email: event.email, errorMessage: ''));
  }

  Future<void> _onSubmitForgotPassword(
    ForgotPasswordSubmitted event,
    Emitter<PasswordState> emit,
  ) async {
    emit(state.copyWith(status: PasswordStatus.loading, errorMessage: ''));

    try {
      final supabase = Supabase.instance.client;

      await supabase.auth.resetPasswordForEmail(state.email);

      emit(state.copyWith(status: PasswordStatus.success, errorMessage: ''));
    } on AuthException catch (e) {
      if (e.message.contains("User not found")) {
        emit(
          state.copyWith(
            status: PasswordStatus.failure,
            errorMessage: "Email chưa được đăng ký.",
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: PasswordStatus.failure,
            errorMessage: e.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: PasswordStatus.failure,
          errorMessage: "Lỗi không xác định. Vui lòng thử lại.",
        ),
      );
    }
  }
}
