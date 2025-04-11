abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String task;
  AddTodo(this.task);
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
