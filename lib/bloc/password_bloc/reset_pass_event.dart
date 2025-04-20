abstract class ResetPasswordEvent {}

/// Gửi token từ URL khi người dùng nhấn vào link email
class TokenReceived extends ResetPasswordEvent {
  final String token;
  TokenReceived(this.token);
}

/// Cập nhật OTP khi người dùng nhập
class OtpChanged extends ResetPasswordEvent {
  final String otp;
  OtpChanged(this.otp);
}

/// Gửi OTP lên để xác thực
class VerifyOtpSubmitted extends ResetPasswordEvent {}

/// Nhập mật khẩu mới
class PasswordChanged extends ResetPasswordEvent {
  final String password;
  PasswordChanged(this.password);
}

/// Gửi yêu cầu cập nhật mật khẩu mới sau khi OTP hợp lệ
class SubmitNewPassword extends ResetPasswordEvent {
  final String token;
  final String newPassword;

  SubmitNewPassword({required this.token, required this.newPassword});
}