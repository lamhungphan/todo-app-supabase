import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_supabase/bloc/password_bloc/forgot_pass_bloc.dart';
import 'package:todo_supabase/bloc/password_bloc/forgot_pass_event.dart';
import 'package:todo_supabase/bloc/password_bloc/forgot_pass_state.dart';

class ForgotPassView extends StatefulWidget {
  const ForgotPassView({super.key});

  @override
  State<ForgotPassView> createState() => _ForgotPassViewState();
}

class _ForgotPassViewState extends State<ForgotPassView> {
  final _forgotPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.blueAccent,
            size: 40,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Forgot Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _forgotPassController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              BlocConsumer<ForgotPassBloc, PasswordState>(
                listener: (context, state) {
                  if (state.status == PasswordStatus.loading) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const AlertDialog(
                        content: Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 10),
                            Text("Sending reset link..."),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // Always close loading dialog if open
                    Navigator.of(context, rootNavigator: true).pop();

                    if (state.status == PasswordStatus.codeSent) {
                      // Navigate to the OTP screen
                      Navigator.pushNamed(context, '/verify');
                    } else if (state.status == PasswordStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.errorMessage.isNotEmpty
                                ? state.errorMessage
                                : "Unknown error",
                          ),
                        ),
                      );
                    }
                  }
                },
                builder: (context, state) {
                  return FilledButton(
                    onPressed: () {
                      final email = _forgotPassController.text.trim();
                      if (email.isNotEmpty) {
                        context.read<ForgotPassBloc>().add(
                              ForgotPassEmailChanged(email),
                            );
                        context.read<ForgotPassBloc>().add(
                              ForgotPassSubmitted(),
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a valid email"),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 6, 33, 185),
                      ),
                      foregroundColor: WidgetStateProperty.all<Color>(
                        Colors.white,
                      ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(vertical: 16),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: const SizedBox(
                      width: 300,
                      child: Center(
                        child: Text('Submit', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
