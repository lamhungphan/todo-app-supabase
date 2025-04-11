import 'package:equatable/equatable.dart';
import 'package:todo_supabase/models/todo.dart';

enum TodoStatus { initial, loading, success, failure }

class TodoState extends Equatable {
  final List<Todo> todos;
  final TodoStatus status;

  const TodoState({
    this.todos = const [],
    this.status = TodoStatus.initial,
  });

  TodoState copyWith({
    List<Todo>? todos,
    TodoStatus? status,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [todos, status];
}
