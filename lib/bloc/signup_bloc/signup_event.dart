abstract class SignupEvent {}

class Signup extends SignupEvent{
  final String email;
  final String password;
  final String confirmPassword;

  Signup({required this.email, required this.password, required this.confirmPassword});
}