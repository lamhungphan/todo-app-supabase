import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_supabase/bloc/signup_bloc/signup_bloc.dart';
import 'package:todo_supabase/bloc/signup_bloc/signup_state.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupBloc(),
      child: const SignupScreenView(),
    );
  }
}

class SignupScreenView extends StatefulWidget {
  const SignupScreenView({super.key});

  @override
  State<SignupScreenView> createState() => _SignupScreenViewState();
}

class _SignupScreenViewState extends State<SignupScreenView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up successful! Please check your email.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error during sign up: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Đăng ký thành công!")));
        } else if (state.status == SignupStatus.failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Đăng ký thất bại!")));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Đăng ký")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Mật khẩu"),
                ),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Xác nhận mật khẩu",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      state.status == SignupStatus.loading
                          ? null
                          : _signUp,
                  child:
                      state.status == SignupStatus.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Đăng ký"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
