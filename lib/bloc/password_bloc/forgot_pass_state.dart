enum PasswordStatus {
  init,
  loading,
  codeSent,
  verifyingCode,
  codeVerified,
  resettingPassword,
  success,
  failure
}

class PasswordState {
  final PasswordStatus status;
  final String email;
  final String errorMessage;

  PasswordState({
    required this.status,
    this.email = '',
    this.errorMessage = '',
  });

  PasswordState copyWith({
    PasswordStatus? status,
    String? email,
    String? errorMessage,
  }) {
    return PasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
