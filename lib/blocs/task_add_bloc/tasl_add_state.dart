import 'package:todo_app/data/models/task_model.dart';

class TaskAddState {
  final String text;
  final DateTime? date;
  final TaskCategory? category;
  TaskAddState({
    this.text = '',
    this.date,
    this.category,
  });

  TaskAddState copyWith({
    String? text,
    DateTime? date,
    TaskCategory? category,
  }) {
    return TaskAddState(
      text: text ?? this.text,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }
}
