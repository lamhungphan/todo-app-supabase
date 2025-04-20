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
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading, errorMessage: null));
    try {
      // Kiểm tra người dùng đã đăng nhập
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      print('User ID: ${user.id}');

      // Tạo truy vấn với filter
      var query = _supabase.from('todo').select().eq('user_id', user.id);
      print('Query after select and eq: $query');

      // Áp dụng tìm kiếm nếu có searchQuery
      if (state.searchQuery.isNotEmpty) {
        query = query.ilike('name', '%${state.searchQuery}%');
        print('Query after ilike: $query');
      }

      // Áp dụng sắp xếp
      final sortField = state.sortBy == TodoSortBy.createdAt
          ? 'created_at'
          : state.sortBy == TodoSortBy.name
              ? 'name'
              : 'priority';
      query.order(sortField, ascending: state.isAscending);
      print('Query after order: $query');

      final response = await query;
      print('Response: $response');
      final todos = (response as List).map((e) => Todo.fromJson(e)).toList();

      emit(
        state.copyWith(
          status: TodoStatus.success,
          todos: todos,
          errorMessage: null,
        ),
      );
    } catch (e) {
      print('Error loading todos: $e');
      String errorMessage;
      if (e is supabase.AuthException) {
        errorMessage = 'Authentication error: ${e.message}';
      } else if (e is supabase.PostgrestException) {
        errorMessage = 'Database error: ${e.message}';
      } else if (e is NoSuchMethodError) {
        errorMessage = 'Internal error: Failed to access database';
      } else {
        errorMessage = 'Failed to load todos: ${e.toString()}';
      }
      emit(
        state.copyWith(status: TodoStatus.failure, errorMessage: errorMessage),
      );
    }
  }

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
      print('Error adding todo: $e');
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          errorMessage: 'Failed to add todo: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      await _supabase.from('todo').delete().eq('id', event.id);
      add(LoadTodos());
    } catch (e) {
      print('Error deleting todo: $e');
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          errorMessage: 'Failed to delete todo: ${e.toString()}',
        ),
      );
    }
  }

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
      print('Error toggling todo: $e');
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          errorMessage: 'Failed to toggle todo: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onSearchTodos(
    SearchTodos event,
    Emitter<TodoState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    add(LoadTodos());
  }

  Future<void> _onSortTodos(SortTodos event, Emitter<TodoState> emit) async {
    emit(state.copyWith(sortBy: event.sortBy, isAscending: event.isAscending));
    add(LoadTodos());
  }
}