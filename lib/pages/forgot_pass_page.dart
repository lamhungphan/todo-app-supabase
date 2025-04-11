import 'package:flutter/material.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final _forgotPassController = TextEditingController();

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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
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
              SizedBox(height: 20),
              FilledButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    const Color.fromARGB(255, 6, 33, 185),
                  ),
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: 16),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
