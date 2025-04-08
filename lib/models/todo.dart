class Todo {
  final String id;
  final String userId;
  final String task;
  final bool isCompleted;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.userId,
    required this.task,
    required this.isCompleted,
    required this.createdAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'].toString(),
      userId: json['user_id'],
      task: json['task'],
      isCompleted: json['is_completed'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'task': task,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
