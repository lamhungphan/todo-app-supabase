import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_supabase/bloc/todo_bloc/todo_bloc.dart';
import 'package:todo_supabase/bloc/todo_bloc/todo_event.dart';
import 'package:todo_supabase/bloc/todo_bloc/todo_state.dart';

import 'package:todo_supabase/pages/views/login/login_provider.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTodo() {
    final task = _taskController.text.trim();
    if (task.isNotEmpty) {
      context.read<TodoBloc>().add(AddTodo(task));
      _taskController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginProvider()),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(labelText: 'New Task'),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _addTodo),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state.status == TodoStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == TodoStatus.failure) {
                  return const Center(child: Text('Failed to fetch todos'));
                } else if (state.todos.isEmpty) {
                  return const Center(child: Text('No todos yet'));
                }

                return ListView.builder(
                  itemCount: state.todos.length,
                  itemBuilder: (context, index) {
                    final todo = state.todos[index];
                    return ListTile(
                      title: Text(todo.task),
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged:
                            (_) => context.read<TodoBloc>().add(
                              ToggleTodo(todo.id, todo.isCompleted),
                            ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed:
                            () => context.read<TodoBloc>().add(
                              DeleteTodo(todo.id),
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
