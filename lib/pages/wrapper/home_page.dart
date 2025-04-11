import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_supabase/bloc/todo_bloc/todo_bloc.dart';
import 'package:todo_supabase/bloc/todo_bloc/todo_event.dart';
import 'package:todo_supabase/pages/views/home_page_view.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoBloc(Supabase.instance.client)..add(LoadTodos()),
      child: const HomeScreenView(),
    );
  }
}
