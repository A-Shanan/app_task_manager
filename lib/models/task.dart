class Task {
  final int id;
  final String title;
  final bool completed;
  final int userId;

  Task(
      {required this.id,
      required this.title,
      required this.completed,
      required this.userId});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      title: json['todo'] ?? '',
      completed: json['completed'] ?? false,
      userId: json['userId'] ?? 0,
    );
  }
}
