import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/tasks_bloc/task_cubit.dart';
import 'package:todo_app/data/models/task_model.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Projects',
                  style: TextStyle(fontWeight: FontWeight.w600),
                )),
            Wrap(
              children: const [
                TaskCategoryWidget(
                    category: TaskCategory.personal,
                    icon: 'assets/images/user.png'),
                TaskCategoryWidget(
                    category: TaskCategory.work,
                    icon: 'assets/images/briefcase.png'),
                TaskCategoryWidget(
                    category: TaskCategory.meeting,
                    icon: 'assets/images/presentation.png'),
                TaskCategoryWidget(
                    category: TaskCategory.shopping,
                    icon: 'assets/images/shopping-basket.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TaskCategoryWidget extends StatelessWidget {
  const TaskCategoryWidget(
      {Key? key, required this.category, required this.icon})
      : super(key: key);
  final TaskCategory category;
  final String icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width / 2.2,
      height: MediaQuery.of(context).size.width / 1.7,
      child: Card(
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 10,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(),
              Column(
                children: [
                  CircleAvatar(
                      backgroundColor: TaskColor.taskCategoryColor[category]!
                          .withOpacity(0.2),
                      radius: MediaQuery.of(context).size.width / 12,
                      child: Image.asset(icon)),
                  Text(
                      '${category.name[0].toUpperCase()}${category.name.replaceRange(0, 1, '')}'),
                ],
              ),
              Text(
                BlocProvider.of<TaskBloc>(context)
                    .getTaskCategoryCount(category),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
