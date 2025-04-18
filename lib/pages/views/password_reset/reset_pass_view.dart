import 'package:flutter/material.dart';

class ResetPassView extends StatefulWidget {
  const ResetPassView({super.key});

  @override
  State<ResetPassView> createState() => _ResetPassViewState();
}

class _ResetPassViewState extends State<ResetPassView> {
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.blueAccent,
            size: 40,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Reset Password',
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
                  controller: _newPassController,
                  obscureText: _obscureText,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    labelText: 'Enter new password',
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _confirmPassController,
                  obscureText: _obscureConfirmText,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Re-enter Password',
                    labelText: 'Confirm password',
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmText
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmText = !_obscureConfirmText;
                        });
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: 300,
                child: FilledButton(
                  onPressed: () {
                    if (_newPassController.text !=
                        _confirmPassController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Passwords do not match'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      //
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
                  child: const Text('Submit', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
