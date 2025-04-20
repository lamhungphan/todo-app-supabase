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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoBloc>().add(LoadTodos());
    });
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
      context.read<TodoBloc>().add(AddTodo(name: name, priority: 'medium'));
      _nameController.clear();
    }
  }

  void _handleSortChange(TodoSortBy? value) {
    setState(() {
      _selectedSortBy = value ?? TodoSortBy.createdAt;
    });

    if (value != null) {
      context.read<TodoBloc>().add(SortTodos(value, _isAscending));
    } else {
      context.read<TodoBloc>().add(LoadTodos());
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<TodoSortBy?>(
                    decoration: const InputDecoration(
                      labelText: 'Sort',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    value: _selectedSortBy,
                    items: [
                      const DropdownMenuItem<TodoSortBy?>(
                        value: null,
                        child: Text('All'),
                      ),
                      ...TodoSortBy.values.map((sortBy) {
                        return DropdownMenuItem<TodoSortBy?>(
                          value: sortBy,
                          child: Text(
                            sortBy == TodoSortBy.createdAt
                                ? 'Created at'
                                : sortBy == TodoSortBy.name
                                ? 'Name'
                                : 'Priority',
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: _handleSortChange,
                  ),
                ),
                const SizedBox(width: 8),
                Checkbox(
                  value: _isAscending,
                  onChanged: (value) {
                    setState(() {
                      _isAscending = value ?? false;
                    });
                    context.read<TodoBloc>().add(
                      SortTodos(_selectedSortBy, _isAscending),
                    );
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
                          onPressed:
                              () => context.read<TodoBloc>().add(LoadTodos()),
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
                        onChanged:
                            (_) => context.read<TodoBloc>().add(
                              ToggleTodo(todo.id, todo.isCompleted ?? false),
                            ),
                      ),
                      trailing: SizedBox(
                        width: 96,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                final nameController = TextEditingController(
                                  text: todo.name,
                                );
                                final descriptionController =
                                    TextEditingController(
                                      text: todo.description,
                                    );
                                String selectedPriority =
                                    todo.priority ?? 'medium';
                                final todoBloc = context.read<TodoBloc>();

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return BlocProvider.value(
                                      value: todoBloc,
                                      child: StatefulBuilder(
                                        builder:
                                            (context, setState) => AlertDialog(
                                              title: const Text(
                                                'Chỉnh sửa công việc',
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: nameController,
                                                    decoration:
                                                        const InputDecoration(
                                                          labelText: 'Tên',
                                                        ),
                                                  ),
                                                  TextField(
                                                    controller:
                                                        descriptionController,
                                                    decoration:
                                                        const InputDecoration(
                                                          labelText: 'Mô tả',
                                                        ),
                                                  ),
                                                  DropdownButtonFormField<
                                                    String
                                                  >(
                                                    value: selectedPriority,
                                                    items:
                                                        [
                                                          'low',
                                                          'medium',
                                                          'high',
                                                        ].map((priority) {
                                                          return DropdownMenuItem(
                                                            value: priority,
                                                            child: Text(
                                                              priority
                                                                  .toUpperCase(),
                                                            ),
                                                          );
                                                        }).toList(),
                                                    onChanged: (value) {
                                                      if (value != null) {
                                                        setState(() {
                                                          selectedPriority =
                                                              value;
                                                        });
                                                      }
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                          labelText:
                                                              'Mức độ ưu tiên',
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () =>
                                                          Navigator.of(
                                                            context,
                                                          ).pop(),
                                                  child: const Text('Hủy'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    context.read<TodoBloc>().add(
                                                      EditTodo(
                                                        id: todo.id,
                                                        name:
                                                            nameController.text,
                                                        description:
                                                            descriptionController
                                                                .text,
                                                        priority:
                                                            selectedPriority,
                                                      ),
                                                    );
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Lưu'),
                                                ),
                                              ],
                                            ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed:
                                  () => context.read<TodoBloc>().add(
                                    DeleteTodo(todo.id),
                                  ),
                            ),
                          ],
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
