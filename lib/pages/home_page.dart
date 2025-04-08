import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_supabase/pages/login_page.dart';
import 'package:todo_supabase/models/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabase = Supabase.instance.client;
  final _taskController = TextEditingController();
  List<Todo> _todos = [];
  bool _isLoading = false;

  // Filter and sort options
  String _filterBy = 'all'; // 'all', 'completed', 'incomplete'
  String _sortBy = 'newest'; // 'newest', 'oldest'

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Base query
      var query = _supabase
          .from('todos')
          .select()
          .eq('user_id', _supabase.auth.currentUser!.id);

      // Apply filter
      if (_filterBy == 'completed') {
        query = query.eq('is_completed', true);
      } else if (_filterBy == 'incomplete') {
        query = query.eq('is_completed', false);
      }

      // Apply sort
      final finalQuery = _sortBy == 'newest'
          ? query.order('created_at', ascending: false)
          : query.order('created_at', ascending: true);

      final response = await finalQuery;

      setState(() {
        _todos = (response as List).map((todo) => Todo.fromJson(todo)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching todos: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addTodo() async {
    if (_taskController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _supabase.from('todos').insert({
        'user_id': _supabase.auth.currentUser!.id,
        'task': _taskController.text.trim(),
        'is_completed': false,
      });

      _taskController.clear();
      _fetchTodos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding todo: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleTodoCompletion(Todo todo) async {
    try {
      await _supabase
          .from('todos')
          .update({'is_completed': !todo.isCompleted}).eq('id', todo.id);

      _fetchTodos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating todo: $e')),
      );
    }
  }

  Future<void> _deleteTodo(String id) async {
    try {
      await _supabase.from('todos').delete().eq('id', id);
      _fetchTodos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting todo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        actions: [
          // Filter dropdown
          DropdownButton<String>(
            value: _filterBy,
            onChanged: (value) {
              setState(() {
                _filterBy = value!;
                _fetchTodos();
              });
            },
            items: [
              DropdownMenuItem(value: 'all', child: Text('All')),
              DropdownMenuItem(value: 'completed', child: Text('Completed')),
              DropdownMenuItem(value: 'incomplete', child: Text('Incomplete')),
            ],
          ),
          // Sort dropdown
          DropdownButton<String>(
            value: _sortBy,
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
                _fetchTodos();
              });
            },
            items: [
              DropdownMenuItem(value: 'newest', child: Text('Newest First')),
              DropdownMenuItem(value: 'oldest', child: Text('Oldest First')),
            ],
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _supabase.auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreenView()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _taskController,
                          decoration: InputDecoration(labelText: 'New Task'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addTodo,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return ListTile(
                        title: Text(todo.task),
                        leading: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (value) => _toggleTodoCompletion(todo),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTodo(todo.id),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
