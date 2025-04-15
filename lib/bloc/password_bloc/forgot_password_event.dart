abstract class ForgotPasswordEvent{}

class ForgotPasswordEmailChanged extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordEmailChanged(this.email);
}

class ForgotPasswordSubmitted extends ForgotPasswordEvent {}

class ResetPasswordSubmitted extends ForgotPasswordEvent {
  final String token;
  final String newPassword;
  ResetPasswordSubmitted(this.token, this.newPassword);
}
