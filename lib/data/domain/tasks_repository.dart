import 'package:todo_app/data/models/task_model.dart';

class TaskRepository {
  const TaskRepository();

  List<TaskModel> taskDelete(int index, List<TaskModel> tasks) {
    tasks.removeAt(index);
    return tasks;
  }

  List<TaskModel> taskChanged({
    required TaskModel task,
    required int index,
    required List<TaskModel> tasks,
  }) {
    tasks[index] = task;
    return tasks;
  }

  List<TaskModel> taskAdd({
    required TaskModel task,
    required List<TaskModel> tasks,
  }) {
    tasks.add(task);
    return tasks;
  }
}
