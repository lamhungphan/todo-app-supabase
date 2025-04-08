import 'package:flutter/material.dart';
import 'package:todo_supabase/auth_wrapper.dart';

// scalable
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo Supabase",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(),
    );
  }
}