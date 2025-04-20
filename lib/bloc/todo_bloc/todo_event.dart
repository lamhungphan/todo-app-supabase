import 'package:todo_supabase/bloc/todo_bloc/todo_state.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String name;
  final String? description;
  final String priority;
  AddTodo({
    required this.name,
    this.description,
    required this.priority,
  });
}

class DeleteTodo extends TodoEvent {
  final String id;
  DeleteTodo(this.id);
}

class ToggleTodo extends TodoEvent {
  final String id;
  final bool isCompleted;
  ToggleTodo(this.id, this.isCompleted);
}

class SearchTodos extends TodoEvent {
  final String query;
  SearchTodos(this.query);
}

class SortTodos extends TodoEvent {
  final TodoSortBy sortBy;
  final bool isAscending;
  SortTodos(this.sortBy, this.isAscending);
}

class EditTodo extends TodoEvent {
  final String id;
  final String name;
  final String description;
  final String priority;

  EditTodo({
    required this.id,
    required this.name,
    required this.description,
    required this.priority,
  });
}
