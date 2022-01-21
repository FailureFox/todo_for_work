import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/tasks_bloc/tasks_state.dart';
import 'package:todo_app/data/domain/tasks_domain.dart';
import 'package:todo_app/data/domain/tasks_repository.dart';
import 'package:todo_app/data/models/task_model.dart';

class TaskBloc extends Cubit<TaskState> {
  final TasksDomain taskDomain;
  final TaskRepository taskRepository;
  TaskBloc({required this.taskDomain, required this.taskRepository})
      : super(const TaskInitialState()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    emit(TaskLoadingState());
    try {
      final tasks = await taskDomain.getTasks();
      emit(TaskLoadedState(tasks: tasks));
    } catch (e) {
      emit(TaskLoadingErrorState(
          error: e.toString().replaceAll('Exception:', '')));
    }
  }

  Future<void> taskDelete(int index) async {
    try {
      final mystate = state as TaskLoadedState;
      final tasks = taskRepository.taskDelete(index, mystate.tasks);
      emit(mystate.copyWith(tasks: tasks));
      await taskDomain.saveTasks(tasks);
    } catch (e) {
      emit(TaskLoadingErrorState(
          error: e.toString().replaceAll('Exception:', '')));
    }
  }

  Future<void> taskChanged(TaskModel task, index) async {
    try {
      final mystate = state as TaskLoadedState;
      final tasks = taskRepository.taskChanged(
          task: task, index: index, tasks: mystate.tasks);
      emit(mystate.copyWith(tasks: tasks));
      await taskDomain.saveTasks(tasks);
    } catch (e) {
      emit(TaskLoadingErrorState(
          error: e.toString().replaceAll('Exception:', '')));
    }
  }

  void dontShowAlert() {
    emit((state as TaskLoadedState).copyWith(showAlert: false));
  }

  void taskAdd(TaskModel task) {
    final tasks = taskRepository.taskAdd(
        task: task, tasks: (state as TaskLoadedState).tasks);
    emit((state as TaskLoadedState).copyWith(tasks: tasks));
    taskDomain.saveTasks(tasks);
  }

  getTaskCategoryCount(TaskCategory category) {
    int count = 0;
    final mystate = state as TaskLoadedState;
    for (var i = 0; i < mystate.tasks.length; i++) {
      mystate.tasks[i].category == category ? count++ : null;
    }
    return count.toString();
  }
}
