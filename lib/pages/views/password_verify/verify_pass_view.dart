import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_supabase/bloc/reset_password_bloc/reset_password_bloc.dart';
import 'package:todo_supabase/bloc/reset_password_bloc/reset_password_event.dart';
import 'package:todo_supabase/bloc/reset_password_bloc/reset_password_state.dart';

class VerifyPassView extends StatefulWidget {
  final String? token;
  const VerifyPassView({super.key, this.token});

  @override
  State<VerifyPassView> createState() => _VerifyPassViewState();
}

class _VerifyPassViewState extends State<VerifyPassView> {
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
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.blueAccent,
            size: 40,
          ),
        ),
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
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 6, 33, 185),
                      ),
                      foregroundColor: WidgetStateProperty.all<Color>(
                        Colors.white,
                      ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 16),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
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
