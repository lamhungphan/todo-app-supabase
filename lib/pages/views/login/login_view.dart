import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_supabase/bloc/login_bloc/login_bloc.dart';
import 'package:todo_supabase/bloc/login_bloc/login_event.dart';
import 'package:todo_supabase/bloc/login_bloc/login_state.dart';
import 'package:todo_supabase/pages/views/password_forgot/forgot_pass_provider.dart';
import 'package:todo_supabase/pages/views/password_reset/reset_pass_provider.dart';
import 'package:todo_supabase/pages/views/password_verify/veriry_pass_provider.dart';
import 'package:todo_supabase/pages/views/signup/signup_provider.dart';
import 'package:todo_supabase/pages/views/todo/todo_provider.dart';

class LoginScreenView extends StatefulWidget {
  const LoginScreenView.LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginScreenView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email and password cannot be empty')),
      );
      return;
    }

    context.read<LoginBloc>().add(Login(email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (BuildContext context, LoginState state) {
        if (state.status == LoginStatus.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TodoProvider()),
          );
        } else if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error during sign in:')));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text('Supabase Todo'),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                            if (_obscureText) {}
                          });
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  state.status == LoginStatus.loading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: _signIn,
                        child: Text('Sign In'),
                      ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupProvider(),
                        ),
                      );
                    },
                    child: const Text("Don't have an account? Sign Up"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPassProvider(),
                        ),
                      );
                    },
                    child: const Text("Forgot password?"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VeriryPassProvider(),
                        ),
                      );
                    },
                    child: const Text("Verify forgot password?"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPassProvider(),
                        ),
                      );
                    },
                    child: const Text("Reset password?"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
