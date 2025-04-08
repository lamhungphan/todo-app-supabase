abstract class LoginEvent {}
// event la hanh dong
// <BlocName><Event>
class Login extends LoginEvent {
  final String email;
  final String password;

  Login({required this.email, required this.password});

}

