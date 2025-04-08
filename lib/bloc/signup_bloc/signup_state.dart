enum SignupStatus { init, success, failure, loading }

class SignupState {
  final SignupStatus status;

  SignupState({required this.status});

  SignupState copyWith({SignupStatus? status}) {
    return SignupState(status: status ?? this.status);
  }
}
