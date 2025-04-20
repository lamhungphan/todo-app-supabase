import 'package:equatable/equatable.dart';
import 'package:todo_supabase/models/todo.dart';

enum TodoStatus { initial, loading, success, failure }

enum TodoSortBy { createdAt, name, priority }

class TodoState extends Equatable {
  final List<Todo> todos;
  final TodoStatus status;
  final String searchQuery;
  final TodoSortBy sortBy;
  final bool isAscending;
  final String? errorMessage; 

  const TodoState({
    this.todos = const [],
    this.status = TodoStatus.initial,
    this.searchQuery = '',
    this.sortBy = TodoSortBy.createdAt,
    this.isAscending = false,
    this.errorMessage,
  });

  TodoState copyWith({
    List<Todo>? todos,
    TodoStatus? status,
    String? searchQuery,
    TodoSortBy? sortBy,
    bool? isAscending,
    String? errorMessage,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      isAscending: isAscending ?? this.isAscending,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [todos, status, searchQuery, sortBy, isAscending, errorMessage];
}
