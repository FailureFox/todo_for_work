import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/task_add_bloc/tasl_add_state.dart';
import 'package:todo_app/data/models/task_model.dart';

class TaskAddBloc extends Cubit<TaskAddState> {
  TaskAddBloc() : super(TaskAddState());

  void taskTitleChanged(String title) {
    emit(state.copyWith(text: title));
  }

  void taskCategoryChanged(TaskCategory category) {
    emit(state.copyWith(category: category));
  }

  void taskDateChanged(DateTime date) {
    emit(state.copyWith(date: date));
  }

  TaskModel? isTaskCompleted() {
    if (state.category != null && state.date != null && state.text != '') {
      return TaskModel(
        text: state.text,
        time: state.date!,
        isAlert: false,
        isCompleted: false,
        category: state.category!,
      );
    }
  }
}
