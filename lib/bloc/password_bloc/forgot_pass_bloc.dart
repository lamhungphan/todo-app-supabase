import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_supabase/bloc/password_bloc/forgot_pass_event.dart';
import 'package:todo_supabase/bloc/password_bloc/forgot_pass_state.dart';

class ForgotPassBloc extends Bloc<ForgotPasswordEvent, PasswordState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  ForgotPassBloc() : super(PasswordState(status: PasswordStatus.init)) {
    on<ForgotPassEmailChanged>(_onEmailChanged);
    on<ForgotPassSubmitted>(_onSubmitForgotPassword);
    on<ForgotPassCodeSubmitted>(_onOtpSubmitted);
    on<ForgotPasswordNewPasswordSubmitted>(_onNewPasswordSubmitted);
  }

  void _onEmailChanged(
    ForgotPassEmailChanged event,
    Emitter<PasswordState> emit,
  ) {
    emit(state.copyWith(email: event.email, errorMessage: ''));
  }

  Future<void> _onSubmitForgotPassword(
    ForgotPassSubmitted event,
    Emitter<PasswordState> emit,
  ) async {
    emit(state.copyWith(status: PasswordStatus.loading, errorMessage: ''));

    try {
      await _supabase.auth.resetPasswordForEmail(state.email.trim());
      emit(state.copyWith(status: PasswordStatus.codeSent, errorMessage: ''));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: PasswordStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PasswordStatus.failure,
        errorMessage: "Lỗi không xác định.",
      ));
    }
  }

  Future<void> _onOtpSubmitted(
    ForgotPassCodeSubmitted event,
    Emitter<PasswordState> emit,
  ) async {
    emit(state.copyWith(status: PasswordStatus.verifyingCode, errorMessage: ''));

    try {
      await _supabase.auth.verifyOTP(
        email: state.email.trim(),
        token: event.code.trim(),
        type: OtpType.recovery,
      );
      emit(state.copyWith(status: PasswordStatus.codeVerified, errorMessage: ''));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: PasswordStatus.failure,
        errorMessage: "Mã xác thực không đúng hoặc đã hết hạn.",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PasswordStatus.failure,
        errorMessage: "Lỗi xác thực mã OTP.",
      ));
    }
  }

  Future<void> _onNewPasswordSubmitted(
    ForgotPasswordNewPasswordSubmitted event,
    Emitter<PasswordState> emit,
  ) async {
    emit(state.copyWith(status: PasswordStatus.resettingPassword, errorMessage: ''));

    try {
      await _supabase.auth.updateUser(UserAttributes(password: event.newPassword));
      emit(state.copyWith(status: PasswordStatus.success, errorMessage: ''));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: PasswordStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PasswordStatus.failure,
        errorMessage: "Lỗi đặt lại mật khẩu.",
      ));
    }
  }
}
