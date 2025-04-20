import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:todo_supabase/bloc/todo_bloc/todo_event.dart';
import 'package:todo_supabase/bloc/todo_bloc/todo_state.dart';
import 'package:todo_supabase/models/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final supabase.SupabaseClient _supabase;

  TodoBloc(this._supabase) : super(const TodoState()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<SearchTodos>(_onSearchTodos);
    on<SortTodos>(_onSortTodos);
    on<EditTodo>(_onEditTodo);
  }

  // ─────────── Load Todos ───────────
  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading, errorMessage: null));
    try {
      final user = _getCurrentUser();
      final query = _buildTodoQuery(user.id);

      final response = await query;
      final todos = _parseTodosFromResponse(response);

      emit(
        state.copyWith(
          status: TodoStatus.success,
          todos: todos,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          errorMessage: _mapLoadTodosError(e),
        ),
      );
    }
  }

  supabase.User _getCurrentUser() {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user;
  }

  supabase.PostgrestTransformBuilder _buildTodoQuery(String userId) {
    var query = _supabase.from('todo').select().eq('user_id', userId);

    if (state.searchQuery.isNotEmpty) {
      query = query.ilike('name', '%${state.searchQuery}%');
    }

    final sortField = switch (state.sortBy) {
      TodoSortBy.createdAt => 'created_at',
      TodoSortBy.name => 'name',
      TodoSortBy.priority => 'priority',
    };

    return query.order(sortField, ascending: state.isAscending);
  }

  List<Todo> _parseTodosFromResponse(dynamic response) {
    return (response as List).map((e) => Todo.fromJson(e)).toList();
  }

  String _mapLoadTodosError(dynamic e) {
    if (e is supabase.AuthException) {
      return 'Authentication error: ${e.message}';
    } else if (e is supabase.PostgrestException) {
      return 'Database error: ${e.message}';
    } else if (e is NoSuchMethodError) {
      return 'Internal error: Failed to access database';
    } else {
      return 'Failed to load todos: ${e.toString()}';
    }
  }

  // ─────────── Add Todo ───────────
  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      await _supabase.from('todo').insert({
        'user_id': _supabase.auth.currentUser!.id,
        'name': event.name,
        'description': event.description,
        'priority': event.priority.isEmpty ? 'medium' : event.priority,
        'is_completed': false,
      });
      add(LoadTodos());
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          errorMessage: 'Failed to add todo: ${e.toString()}',
        ),
      );
    }
  }

  // ─────────── Delete Todo ───────────
  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      await _supabase.from('todo').delete().eq('id', event.id);
      add(LoadTodos());
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          errorMessage: 'Failed to delete todo: ${e.toString()}',
        ),
      );
    }
  }

  // ─────────── Toggle Todo ───────────
  Future<void> _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) async {
    try {
      await _supabase
          .from('todo')
          .update({
            'is_completed': !event.isCompleted,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', event.id);
      add(LoadTodos());
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          errorMessage: 'Failed to toggle todo: ${e.toString()}',
        ),
      );
    }
  }

  // ─────────── Search Todos ───────────
  Future<void> _onSearchTodos(
    SearchTodos event,
    Emitter<TodoState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    add(LoadTodos());
  }

  // ─────────── Sort Todos ───────────
Future<void> _onSortTodos(SortTodos event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      final todos = List<Todo>.from(state.todos);
      todos.sort((a, b) {
        switch (event.sortBy) {
          case TodoSortBy.createdAt:
            final comparison = (a.createdAt ?? DateTime.now())
                .compareTo(b.createdAt ?? DateTime.now());
            return event.isAscending ? comparison : -comparison;
          case TodoSortBy.name:
            final comparison = (a.name ?? '').compareTo(b.name ?? '');
            return event.isAscending ? comparison : -comparison;
          case TodoSortBy.priority:
            const priorityOrder = {'low': 1, 'medium': 2, 'high': 3};
            final comparison = (priorityOrder[a.priority ?? 'medium'] ?? 2)
                .compareTo(priorityOrder[b.priority ?? 'medium'] ?? 2);
            return event.isAscending ? comparison : -comparison;
        }
      });
      emit(state.copyWith(status: TodoStatus.success, todos: todos));
    } catch (e) {
      emit(state.copyWith(
          status: TodoStatus.failure, errorMessage: 'Failed to sort todos'));
    }
  }

  Future<void> _onEditTodo(EditTodo event, Emitter<TodoState> emit) async {
    try {
      await _supabase
          .from('todo')
          .update({
            'name': event.name,
            'description': event.description,
            'priority': event.priority,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', event.id);

      add(LoadTodos());
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          errorMessage: 'Failed to update todo: ${e.toString()}',
        ),
      );
    }
  }
}
