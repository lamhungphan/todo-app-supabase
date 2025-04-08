import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_supabase/bloc/login_bloc/login_bloc.dart';
import 'package:todo_supabase/bloc/login_bloc/login_event.dart';
import 'package:todo_supabase/bloc/login_bloc/login_state.dart';
import 'package:todo_supabase/pages/home_page.dart';
import 'package:todo_supabase/pages/signup_page.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: LoginScreenView(),
    );
  }
}
// listener, builder, consumer

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  _LoginScreenViewState createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;

  Future<void> _signIn() async {
    context.read<LoginBloc>().add(
      Login(email: _emailController.text, password: _passwordController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (BuildContext context, LoginState state) {
        if (state.status == LoginStatus.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error during sign in:')));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('Supabase Todo')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                // chi boc bloc builder o nhung cho can build
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
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
