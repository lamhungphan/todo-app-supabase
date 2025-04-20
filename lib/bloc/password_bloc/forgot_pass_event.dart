abstract class ForgotPasswordEvent {}

class ForgotPassEmailChanged extends ForgotPasswordEvent {
  final String email;
  ForgotPassEmailChanged(this.email);
}

class ForgotPassSubmitted extends ForgotPasswordEvent {}

class ForgotPassCodeSubmitted extends ForgotPasswordEvent {
  final String code;
  ForgotPassCodeSubmitted(this.code);
}

class ForgotPasswordNewPasswordSubmitted extends ForgotPasswordEvent {
  final String newPassword;
  ForgotPasswordNewPasswordSubmitted(this.newPassword);
}
