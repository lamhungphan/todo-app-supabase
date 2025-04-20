import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_supabase/bloc/password_bloc/reset_pass_event.dart';
import 'package:todo_supabase/bloc/password_bloc/reset_pass_state.dart';
import 'dart:async';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(const ResetPasswordState()) {
    on<TokenReceived>((event, emit) {
      emit(state.copyWith(token: event.token));
    });

    on<OtpChanged>((event, emit) {
      emit(state.copyWith(otp: event.otp));
    });

    on<VerifyOtpSubmitted>(_onVerifyOtp);
    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<SubmitNewPassword>(_onSubmitNewPassword);
  }

  /// Xác thực OTP
  Future<void> _onVerifyOtp(
    VerifyOtpSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetStatus.loading));
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase.auth.verifyOTP(
        type: OtpType.recovery,
        token: state.otp,
      );

      if (response.user != null) {
        emit(state.copyWith(status: ResetStatus.success));
      } else {
        emit(state.copyWith(status: ResetStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(status: ResetStatus.failure));
    }
  }

  /// Cập nhật mật khẩu mới
  Future<void> _onSubmitNewPassword(
    SubmitNewPassword event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetStatus.loading));

    try {
      final supabase = Supabase.instance.client;

      // Đổi mật khẩu mới
      await supabase.auth.updateUser(UserAttributes(password: state.password));

      emit(state.copyWith(status: ResetStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ResetStatus.failure));
    }
  }
}
