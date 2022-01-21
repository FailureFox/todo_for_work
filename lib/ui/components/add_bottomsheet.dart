import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/task_add_bloc/task_add_bloc.dart';
import 'package:todo_app/blocs/task_add_bloc/tasl_add_state.dart';
import 'package:todo_app/blocs/tasks_bloc/task_cubit.dart';
import 'package:todo_app/data/models/task_model.dart';

taskAddBottomSheet(BuildContext myContext) {
  final TaskAddBloc bloc = TaskAddBloc();
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: myContext,
    builder: (context) {
      return BlocProvider<TaskAddBloc>(
        create: (_) => bloc,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                  child: ClipPath(
                clipper: MyCustomClipper(),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 12,
                      left: 25,
                      right: 25,
                    ),
                    child: Column(
                      children: [
                        const Center(
                          child: Text(
                            'Add new tasks',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const EditTitleField(),
                        const Divider(),
                        const CategorySelectList(),
                        const Divider(),
                        const SizedBox(height: 20),
                        const SelectDateWidget(),
                        const SizedBox(height: 20),
                        AddAndSaveTaskButton(
                            tasksBloc: BlocProvider.of<TaskBloc>(myContext)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              )),
              TaskAddCloseButton(
                tasksbloc: BlocProvider.of<TaskBloc>(myContext),
              )
            ],
          ),
        ),
      );
    },
  );
}

class SelectDateWidget extends StatelessWidget {
  const SelectDateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose date'),
        Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width / 5),
              child: BlocBuilder<TaskAddBloc, TaskAddState>(
                  builder: (context, state) {
                return Text(
                  getTimeString(state.date),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                );
              }),
            ),
            IconButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  final date = await dateTimeSelect(context);
                  if (date != null) {
                    BlocProvider.of<TaskAddBloc>(context).taskDateChanged(date);
                  }
                },
                icon: const Icon(Icons.expand_more)),
          ],
        ),
      ],
    );
  }

  String getTimeString(DateTime? date) {
    final String dateTimeView;
    if (date != null) {
      final String timeView = '${date.hour}:${date.minute}';
      final int daysdifferences = calculateDifference(date);
      if (daysdifferences == 1) {
        dateTimeView = 'Tomorrow, $timeView';
      } else if (daysdifferences == 0) {
        dateTimeView = 'Today, $timeView';
      } else if (daysdifferences == -1) {
        dateTimeView = 'Yesterday, $timeView';
      } else {
        dateTimeView = '${date.year}.${date.month}.${date.day} $timeView';
      }
    } else {
      dateTimeView = '';
    }
    return dateTimeView;
  }
}

Future<DateTime?> dateTimeSelect(context) async {
  DateTime? date;
  TimeOfDay? time;

  date = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2025, 12, 12),
  );

  if (date != null) {
    time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }
  }
}

int calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}

class AddAndSaveTaskButton extends StatelessWidget {
  const AddAndSaveTaskButton({Key? key, required this.tasksBloc})
      : super(key: key);
  final TaskBloc tasksBloc;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      clipBehavior: Clip.hardEdge,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(0),
          shadowColor: const Color(0xFF6894EE),
          elevation: 10),
      onPressed: () {
        final TaskModel? task =
            BlocProvider.of<TaskAddBloc>(context).isTaskCompleted();
        if (task != null) {
          FocusScope.of(context).unfocus();
          tasksBloc.taskAdd(task);
          Navigator.pop(context);
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.width / 7,
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFF7EB6FF), Color(0xFF5F87E7)])),
        child: const Center(
          child: Text('Add task', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class EditTitleField extends StatelessWidget {
  const EditTitleField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(border: InputBorder.none),
      onChanged: (value) {
        BlocProvider.of<TaskAddBloc>(context).taskTitleChanged(value);
      },
    );
  }
}

class CategorySelectList extends StatelessWidget {
  const CategorySelectList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 7,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          CategorySelectWidget(category: TaskCategory.meeting),
          CategorySelectWidget(category: TaskCategory.personal),
          CategorySelectWidget(category: TaskCategory.shopping),
          CategorySelectWidget(category: TaskCategory.work),
        ],
      ),
    );
  }
}

class CategorySelectWidget extends StatelessWidget {
  const CategorySelectWidget({Key? key, required this.category})
      : super(key: key);
  final TaskCategory category;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<TaskAddBloc>(context).taskCategoryChanged(category);
      },
      child: BlocBuilder<TaskAddBloc, TaskAddState>(builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          height: double.infinity,
          decoration: BoxDecoration(
              color: category == state.category
                  ? TaskColor.taskCategoryColor[category]
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          width: MediaQuery.of(context).size.width / 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                radius: 5,
                backgroundColor: TaskColor.taskCategoryColor[category],
              ),
              Text(
                category.name,
                style: TextStyle(
                    color: state.category == category ? Colors.white : null),
              ),
              const SizedBox(width: 5),
            ],
          ),
        );
      }),
    );
  }
}

class TaskAddCloseButton extends StatelessWidget {
  const TaskAddCloseButton({Key? key, required this.tasksbloc})
      : super(key: key);
  final TaskBloc tasksbloc;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: ElevatedButton(
        clipBehavior: Clip.hardEdge,
        style: ElevatedButton.styleFrom(
            shadowColor: const Color(0xFFF456C3),
            shape: const CircleBorder(),
            elevation: 6),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF857C3),
                Color(0xFFE0139C),
              ],
            ),
          ),
          child: Icon(
            Icons.close,
            size: 55,
          ),
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const Offset p0 = Offset(0, 50);
    final Offset p1 = Offset(size.width / 2, 0);
    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, 50);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 50);
    path.quadraticBezierTo(p1.dx, p1.dy, p0.dx, p0.dy);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
