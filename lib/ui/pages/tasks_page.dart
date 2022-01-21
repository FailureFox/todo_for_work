import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/tasks_bloc/task_cubit.dart';
import 'package:todo_app/blocs/tasks_bloc/tasks_state.dart';
import 'package:todo_app/ui/components/add_bottomsheet.dart';
import 'package:todo_app/ui/components/task_widget.dart';
import 'package:todo_app/ui/screens/onboarding.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
        if (state is TaskLoadedState) {
          if (state.tasks.isNotEmpty) {
            if (state.todayCount == 0 && state.yesterdayCount == 0) {
              return const EmptyTasksWidget();
            } else {
              return ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  if (state.todayCount != 0)
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Today',
                        style: TextStyle(
                            color: AppColors.titleTextColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  for (var i = 0; i < state.tasks.length; i++)
                    if (calculateDifference(state.tasks[i].time) == 0)
                      TasksWidget(model: state.tasks[i], index: i),
                  if (state.yesterdayCount != 0)
                    const Text(
                      'Yesterday',
                      style: TextStyle(
                          color: AppColors.titleTextColor,
                          fontWeight: FontWeight.w600),
                    ),
                  for (var i = 0; i < state.tasks.length; i++)
                    if (calculateDifference(state.tasks[i].time) == 1)
                      TasksWidget(model: state.tasks[i], index: i),
                ],
              );
            }
          } else {
            return const EmptyTasksWidget();
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}

class EmptyTasksWidget extends StatelessWidget {
  const EmptyTasksWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppImages.emptyTasks),
        const SizedBox(height: 40),
        const Text(
          'No tasks',
          style: AppStyles.titleTextStyle,
        )
      ],
    );
  }
}
