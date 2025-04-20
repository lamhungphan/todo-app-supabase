enum PasswordResetStatus {
  initial,
  loading,
  otpSent,
  verifyingOtp,
  otpVerified,
  resettingPassword,
  success,
  failure,
}

class PasswordResetState {
  final PasswordResetStatus status;
  final String email;
  final String errorMessage;

  PasswordResetState({
    required this.status,
    this.email = '',
    this.errorMessage = '',
  });

  PasswordResetState copyWith({
    PasswordResetStatus? status,
    String? email,
    String? errorMessage,
  }) {
    return PasswordResetState(
      status: status ?? this.status,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}