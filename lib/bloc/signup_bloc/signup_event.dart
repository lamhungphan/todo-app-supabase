abstract class SignupEvent {}

class SignupEventSubmitted extends SignupEvent {
  final String email;
  final String password;

  SignupEventSubmitted({
    required this.email,
    required this.password,
  });
}
