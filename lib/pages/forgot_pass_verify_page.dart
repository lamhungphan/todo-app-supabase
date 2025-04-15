import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_supabase/bloc/password_bloc/reset_password_bloc.dart';
import 'package:todo_supabase/bloc/password_bloc/reset_password_event.dart';
import 'package:todo_supabase/bloc/password_bloc/reset_password_state.dart';

class ForgotPassVerifyPage extends StatefulWidget {
  final String? token;
  const ForgotPassVerifyPage({super.key, this.token});

  @override
  State<ForgotPassVerifyPage> createState() => _ForgotPassVerifyPageState();
}

class _ForgotPassVerifyPageState extends State<ForgotPassVerifyPage> {
  final _passController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Nếu có token, gửi event cho bloc
    final token = widget.token;
    if (token != null && token.isNotEmpty) {
      context.read<ResetPasswordBloc>().add(TokenReceived(token));
    }
  }

  @override
  void dispose() {
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state.status == ResetStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Password reset successful")),
            );
          } else if (state.status == ResetStatus.failure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Failed to reset password")));
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Enter your new password",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _passController,
                      onChanged:
                          (value) => context.read<ResetPasswordBloc>().add(
                            PasswordChanged(value),
                          ),
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "New Password",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  FilledButton(
                    onPressed:
                        state.status == ResetStatus.loading
                            ? null
                            : () => context.read<ResetPasswordBloc>().add(
                              SubmitNewPassword(),
                            ),
                    child: SizedBox(
                      width: 300,
                      child: Center(
                        child:
                            state.status == ResetStatus.loading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  "Submit",
                                  style: TextStyle(fontSize: 18),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
