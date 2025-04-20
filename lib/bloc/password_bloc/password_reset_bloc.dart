import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_supabase/bloc/password_bloc/password_reset_event.dart';
import 'package:todo_supabase/bloc/password_bloc/password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  PasswordResetBloc() : super(PasswordResetState(status: PasswordResetStatus.initial)) {
    on<EmailChanged>(_onEmailChanged);
    on<SendOtpRequested>(_onSendOtpRequested);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<NewPasswordSubmitted>(_onNewPasswordSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<PasswordResetState> emit) {
    emit(state.copyWith(email: event.email, errorMessage: ''));
  }

  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<PasswordResetState> emit,
  ) async {
    if (!_isValidEmail(state.email)) {
      emit(state.copyWith(
        status: PasswordResetStatus.failure,
        errorMessage: 'Vui lòng nhập email hợp lệ.',
      ));
      return;
    }

    emit(state.copyWith(status: PasswordResetStatus.loading, errorMessage: ''));

    try {
      await _supabase.auth.resetPasswordForEmail(state.email.trim());
      emit(state.copyWith(status: PasswordResetStatus.otpSent, errorMessage: ''));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: PasswordResetStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PasswordResetStatus.failure,
        errorMessage: 'Lỗi không xác định khi gửi OTP.',
      ));
    }
  }

  Future<void> _onOtpSubmitted(
    OtpSubmitted event,
    Emitter<PasswordResetState> emit,
  ) async {
    if (event.otp.trim().isEmpty) {
      emit(state.copyWith(
        status: PasswordResetStatus.failure,
        errorMessage: 'Vui lòng nhập mã OTP.',
      ));
      return;
    }

    emit(state.copyWith(status: PasswordResetStatus.verifyingOtp, errorMessage: ''));

    try {
      await _supabase.auth.verifyOTP(
        email: state.email.trim(),
        token: event.otp.trim(),
        type: OtpType.recovery,
      );
      emit(state.copyWith(status: PasswordResetStatus.otpVerified, errorMessage: ''));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: PasswordResetStatus.failure,
        errorMessage: 'Mã OTP không đúng hoặc đã hết hạn.',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PasswordResetStatus.failure,
        errorMessage: 'Lỗi xác thực mã OTP.',
      ));
    }
  }

  Future<void> _onNewPasswordSubmitted(
    NewPasswordSubmitted event,
    Emitter<PasswordResetState> emit,
  ) async {
    if (!_isValidPassword(event.newPassword)) {
      emit(state.copyWith(
        status: PasswordResetStatus.failure,
        errorMessage: 'Mật khẩu phải có ít nhất 8 ký tự.',
      ));
      return;
    }

    emit(state.copyWith(status: PasswordResetStatus.resettingPassword, errorMessage: ''));

    try {
      await _supabase.auth.updateUser(UserAttributes(password: event.newPassword));
      emit(state.copyWith(status: PasswordResetStatus.success, errorMessage: ''));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: PasswordResetStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PasswordResetStatus.failure,
        errorMessage: 'Lỗi khi đặt lại mật khẩu.',
      ));
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email.trim());
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }
}