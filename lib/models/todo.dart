class Todo {
  final String id;
  final String? userId;
  final String? name;
  final String? description;
  final String priority;
  final bool? isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Todo({
    required this.id,
    this.userId,
    this.name,
    this.description,
    required this.priority,
    this.isCompleted,
    required this.createdAt,
    this.updatedAt,
  });

  Todo toggleCompletion() {
    return Todo(
      id: id,
      userId: userId,
      name: name,
      description: description,
      priority: priority,
      isCompleted: !(isCompleted ?? false),
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'].toString(), 
      userId: json['user_id']?.toString(), 
      name: json['name'],
      description: json['description'],
      priority: json['priority'] ?? '',
      isCompleted: json['is_completed'], 
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'priority': priority,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
