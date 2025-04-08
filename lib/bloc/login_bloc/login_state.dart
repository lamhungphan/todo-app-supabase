enum LoginStatus {init, success, failure, loading}

class LoginState {
  final LoginStatus status;

  LoginState({ required this.status});

  LoginState copyWith({ LoginStatus? status}) {
    return LoginState(
      status: status ?? this.status,
    );
  }
}