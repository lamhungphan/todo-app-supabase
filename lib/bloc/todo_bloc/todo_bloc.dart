import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_supabase/bloc/todo_bloc/todo_event.dart';
import 'package:todo_supabase/bloc/todo_bloc/todo_state.dart';
import 'package:todo_supabase/models/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final SupabaseClient _supabase;

  TodoBloc(this._supabase) : super(const TodoState()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodo>(_onToggleTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      var query = _supabase
          .from('todos')
          .select()
          .eq('user_id', _supabase.auth.currentUser!.id)
          .order('created_at', ascending: false);

      final response = await query;
      final todos = (response as List).map((e) => Todo.fromJson(e)).toList();

      emit(state.copyWith(status: TodoStatus.success, todos: todos));
    } catch (_) {
      emit(state.copyWith(status: TodoStatus.failure));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    await _supabase.from('todos').insert({
      'user_id': _supabase.auth.currentUser!.id,
      'task': event.task,
      'is_completed': false,
    });
    add(LoadTodos());
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    await _supabase.from('todos').delete().eq('id', event.id);
    add(LoadTodos());
  }

  Future<void> _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) async {
    await _supabase
        .from('todos')
        .update({'is_completed': !event.isCompleted})
        .eq('id', event.id);
    add(LoadTodos());
  }
}
