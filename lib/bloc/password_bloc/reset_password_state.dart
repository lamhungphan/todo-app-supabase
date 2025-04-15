enum ResetStatus { init, loading, success, failure }

class ResetPasswordState {
  final String password;
  final String token;
  final ResetStatus status;

  ResetPasswordState({
    this.password = '',
    this.token = '',
    this.status = ResetStatus.init,
  });

  ResetPasswordState copyWith({
    String? password,
    String? token,
    ResetStatus? status,
  }) {
    return ResetPasswordState(
      password: password ?? this.password,
      token: token ?? this.token,
      status: status ?? this.status,
    );
  }
}
