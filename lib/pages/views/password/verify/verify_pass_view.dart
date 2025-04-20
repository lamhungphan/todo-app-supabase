import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_supabase/bloc/password_bloc/reset_pass_bloc.dart';
import 'package:todo_supabase/bloc/password_bloc/reset_pass_event.dart';
import 'package:todo_supabase/bloc/password_bloc/reset_pass_state.dart';
import 'package:todo_supabase/pages/views/password/reset/reset_pass_provider.dart';

class VerifyPassView extends StatefulWidget {
  final String? token;
  const VerifyPassView({super.key, this.token});

  @override
  State<VerifyPassView> createState() => _VerifyPassViewState();
}

class _VerifyPassViewState extends State<VerifyPassView> {
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final token = widget.token;
    if (token != null && token.isNotEmpty) {
      context.read<ResetPasswordBloc>().add(TokenReceived(token));
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.blueAccent, size: 32),
        ),
      ),
      backgroundColor: Colors.black,
      body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state.status == ResetStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('OTP hợp lệ')),
            );
            // Điều hướng sang màn hình đặt lại mật khẩu
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ResetPassProvider(token: state.token)),
            );
          } else if (state.status == ResetStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('OTP không hợp lệ')),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _otpController,
                      onChanged: (value) => context.read<ResetPasswordBloc>().add(OtpChanged(value)),
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Enter Your OTP Code Sent To Your Email",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty .all<Color>(
                        const Color.fromARGB(255, 6, 33, 185),
                      ),
                      foregroundColor: WidgetStateProperty .all<Color>(Colors.white),
                      padding: WidgetStateProperty .all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 16),
                      ),
                      shape: WidgetStateProperty .all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: state.status == ResetStatus.loading
                        ? null
                        : () => context.read<ResetPasswordBloc>().add(VerifyOtpSubmitted()),
                    child: SizedBox(
                      width: 300,
                      child: Center(
                        child: state.status == ResetStatus.loading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Xác nhận OTP", style: TextStyle(fontSize: 18)),
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
