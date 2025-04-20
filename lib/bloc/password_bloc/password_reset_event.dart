
abstract class PasswordResetEvent {}

class EmailChanged extends PasswordResetEvent {
  final String email;
  EmailChanged(this.email);
}

class SendOtpRequested extends PasswordResetEvent {}

class OtpSubmitted extends PasswordResetEvent {
  final String otp;
  OtpSubmitted(this.otp);
}

class NewPasswordSubmitted extends PasswordResetEvent {
  final String newPassword;
  NewPasswordSubmitted(this.newPassword);
}