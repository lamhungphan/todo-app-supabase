enum PasswordStatus { init, loading, success, failure }

class PasswordState {
  final PasswordStatus status;
  final String email;

  PasswordState({required this.status, this.email = ''});

  get errorMessage => null;

  PasswordState copyWith({PasswordStatus? status, String? email, required String errorMessage}) {
    return PasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
    );
  }
}
