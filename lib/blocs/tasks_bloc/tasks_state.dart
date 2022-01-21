import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/ui/components/add_bottomsheet.dart';

abstract class TaskState {
  const TaskState();
}

class TaskInitialState extends TaskState {
  const TaskInitialState();
}

class TaskLoadingState extends TaskState {}

class TaskLoadedState extends TaskState {
  final List<TaskModel> tasks;
  late final int todayCount;
  late final int yesterdayCount;
  late final TaskModel? taskHavedAlert;
  final bool showAlert;
  TaskLoadedState({required this.tasks, this.showAlert = true}) {
    todayCount = getTaskForTodayCount();
    yesterdayCount = getTaskYesterdayCount();
    taskHavedAlert = getTaskHavedAlert();
  }

  TaskLoadedState copyWith({List<TaskModel>? tasks, bool? showAlert}) {
    return TaskLoadedState(
        tasks: tasks ?? this.tasks, showAlert: showAlert ?? this.showAlert);
  }

  getTaskHavedAlert() {
    for (var item in tasks) {
      tasks.sort((a, b) {
        return a.time.compareTo(b.time);
      });
      if (item.isAlert && calculateDifference(item.time) == 0) {
        return item;
      }
    }
    return null;
  }

  getTaskForTodayCount() {
    int count = 0;
    for (var task in tasks) {
      calculateDifference(task.time) == 0 ? count++ : null;
    }
    return count;
  }

  getTaskYesterdayCount() {
    int count = 0;
    for (var task in tasks) {
      calculateDifference(task.time) == 1 ? count++ : null;
    }
    return count;
  }
}

class TaskLoadingErrorState extends TaskState {
  final String error;
  const TaskLoadingErrorState({required this.error});
}
