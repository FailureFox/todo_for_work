import 'package:todo_app/data/models/task_model.dart';
import 'package:hive/hive.dart';

class TasksDomain {
  TasksDomain();
  Future<List<TaskModel>> getTasks() async {
    final tasksBox = await Hive.openBox('tasks');
    final tasksListMap = (tasksBox.get('tasks', defaultValue: []) as List);

    Hive.close();
    return tasksListMap.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final tasksBox = await Hive.openBox('tasks');
    tasksBox.delete('tasks');
    await tasksBox.put('tasks', tasks.map((e) => e.toMap()).toList());
  }
}
