import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/blocs/tasks_bloc/task_cubit.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/ui/screens/onboarding.dart';

class TasksWidget extends StatelessWidget {
  const TasksWidget({Key? key, required this.model, required this.index})
      : super(key: key);
  final TaskModel model;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      endActionPane:
          ActionPane(extentRatio: 0.3, motion: const ScrollMotion(), children: [
        Center(
          child: CircleAvatar(
            backgroundColor: const Color(0xFFC4CEF5),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.edit_outlined,
                color: Color(0xFF5F87E7),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Center(
          child: CircleAvatar(
            backgroundColor: const Color(0xFFFFCFCF),
            child: IconButton(
                onPressed: () {
                  BlocProvider.of<TaskBloc>(context).taskDelete(index);
                },
                icon: const Icon(
                  Icons.delete_forever_outlined,
                  color: Color(0xFFFB3636),
                )),
          ),
        ),
      ]),
      child: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        height: MediaQuery.of(context).size.height / 12,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: double.infinity,
              color: TaskColor.taskCategoryColor[model.category],
              width: 5,
            ),
            Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                value: model.isCompleted,
                fillColor: MaterialStateProperty.all(const Color(0xFF91DC5A)),
                onChanged: (value) {
                  BlocProvider.of<TaskBloc>(context)
                      .taskChanged(model.copyWith(isCompleted: value), index);
                }),
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(bottom: 15, left: 10),
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('hh.mm a').format(model.time),
                      style: const TextStyle(
                        color: Colors.black26,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Text(
                        model.text,
                        style: const TextStyle(
                          color: AppColors.titleTextColor,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: const CircleBorder(),
              child: IconButton(
                splashRadius: 15,
                onPressed: () {
                  BlocProvider.of<TaskBloc>(context).taskChanged(
                      model.copyWith(isAlert: !model.isAlert), index);
                },
                icon: Icon(
                  Icons.notifications,
                  size: 20,
                  color: model.isAlert
                      ? const Color(0xFFFFDC00)
                      : const Color(0xFFD9D9D9),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
