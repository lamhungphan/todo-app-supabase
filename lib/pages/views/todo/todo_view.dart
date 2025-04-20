import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
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
  final _nameController = TextEditingController();
  final _searchController = TextEditingController();
  TodoSortBy _selectedSortBy = TodoSortBy.createdAt;
  bool _isAscending = false;

  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(LoadTodos());
    _searchController.addListener(() {
      context.read<TodoBloc>().add(SearchTodos(_searchController.text.trim()));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addTodo() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      context.read<TodoBloc>().add(AddTodo(
        name: name,
        priority: 'medium',
      ));
      _nameController.clear();
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
              await supabase.Supabase.instance.client.auth.signOut();
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<TodoSortBy>(
              value: _selectedSortBy,
              items: TodoSortBy.values.map((sortBy) {
                return DropdownMenuItem<TodoSortBy>(
                  value: sortBy,
                  child: Text(
                    sortBy == TodoSortBy.createdAt
                        ? 'Created At'
                        : sortBy == TodoSortBy.name
                            ? 'Name'
                            : 'Priority',
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSortBy = value;
                  });
                  context.read<TodoBloc>().add(SortTodos(value, _isAscending));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Checkbox(
                  value: _isAscending,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _isAscending = value;
                      });
                      context
                          .read<TodoBloc>()
                          .add(SortTodos(_selectedSortBy, value));
                    }
                  },
                ),
                const Text('Ascending'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.errorMessage ?? 'Failed to fetch todos',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<TodoBloc>().add(LoadTodos()),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                } else if (state.todos.isEmpty) {
                  return const Center(child: Text('No todos yet'));
                }

                return ListView.builder(
                  itemCount: state.todos.length,
                  itemBuilder: (context, index) {
                    final todo = state.todos[index];
                    return ListTile(
                      title: Text(todo.name ?? 'No Name'),
                      subtitle: Text('Priority: ${todo.priority}'),
                      leading: Checkbox(
                        value: todo.isCompleted ?? false,
                        onChanged: (_) => context.read<TodoBloc>().add(
                              ToggleTodo(
                                  todo.id, todo.isCompleted ?? false),
                            ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            context.read<TodoBloc>().add(
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
