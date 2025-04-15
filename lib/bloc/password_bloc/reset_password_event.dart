abstract class ResetPasswordEvent {}

class PasswordChanged extends ResetPasswordEvent {
  final String password;
  PasswordChanged(this.password);
}

class SubmitNewPassword extends ResetPasswordEvent {}

class TokenReceived extends ResetPasswordEvent {
  final String accessToken;
  TokenReceived(this.accessToken);

  get token => null;
}
