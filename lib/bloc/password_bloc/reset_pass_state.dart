enum ResetStatus { initial, loading, success, failure }

class ResetPasswordState {
  final String token;
  final String otp;
  final String password;  // Thêm thuộc tính password
  final ResetStatus status;

  const ResetPasswordState({
    this.token = '',
    this.otp = '',
    this.password = '',
    this.status = ResetStatus.initial,
  });

  // Cập nhật hàm copyWith để bao gồm password
  ResetPasswordState copyWith({
    String? token,
    String? otp,
    String? password,
    ResetStatus? status,
  }) {
    return ResetPasswordState(
      token: token ?? this.token,
      otp: otp ?? this.otp,
      password: password ?? this.password,  // Cập nhật password
      status: status ?? this.status,
    );
  }
}
