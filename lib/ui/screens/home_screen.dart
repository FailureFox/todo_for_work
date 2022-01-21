import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/blocs/app_bloc/app_bloc.dart';
import 'package:todo_app/blocs/app_bloc/app_state.dart';
import 'package:todo_app/blocs/tasks_bloc/task_cubit.dart';
import 'package:todo_app/blocs/tasks_bloc/tasks_state.dart';
import 'package:todo_app/data/domain/tasks_domain.dart';
import 'package:todo_app/data/domain/tasks_repository.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/ui/components/add_bottomsheet.dart';
import 'package:todo_app/ui/pages/category_page.dart';
import 'package:todo_app/ui/pages/tasks_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        bottomNavigationBar: const HomeBottomBar(),
        body: BlocBuilder<HomeBloc, HomeState>(
            bloc: HomeInheritedWidget.of(context)!.bloc,
            builder: (context, state) {
              return Column(
                children: [
                  const HomeScreenAppbar(),
                  (state as HomeLoadedState).page == 0
                      ? const TasksPage()
                      : const CategoryPage(),
                  SizedBox(height: MediaQuery.of(context).size.height / 12)
                ],
              );
            }));
  }
}

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 12,
          color: Colors.white,
          child: BlocBuilder<HomeBloc, HomeState>(
              bloc: HomeInheritedWidget.of(context)!.bloc,
              builder: (context, state) {
                if (state is HomeLoadedState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          HomeInheritedWidget.of(context)!.bloc.changePage(0);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home_rounded,
                                color: state.page == 0
                                    ? Colors.black
                                    : const Color(0xFFBEBEBE)),
                            Text('Home',
                                style: TextStyle(
                                    color: state.page == 0
                                        ? Colors.black
                                        : const Color(0xFFBEBEBE),
                                    fontSize: 10))
                          ],
                        ),
                      ),
                      const SizedBox(),
                      GestureDetector(
                        onTap: () {
                          HomeInheritedWidget.of(context)!.bloc.changePage(1);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.grid_view_outlined,
                              color: state.page == 1
                                  ? Colors.black
                                  : const Color(0xFFBEBEBE),
                            ),
                            Text(
                              'Task',
                              style: TextStyle(
                                  color: state.page == 1
                                      ? Colors.black
                                      : const Color(0xFFBEBEBE),
                                  fontSize: 10),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  return Container();
                }
              }),
        ),
        Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(
              bottom: (MediaQuery.of(context).size.height / 12) / 2),
          child: ElevatedButton(
            clipBehavior: Clip.hardEdge,
            style: ElevatedButton.styleFrom(
                shadowColor: const Color(0xFFF456C3),
                shape: const CircleBorder(),
                elevation: 6),
            onPressed: () {
              taskAddBottomSheet(context);
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
                Icons.add,
                size: 55,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class HomeScreenAppbar extends StatelessWidget {
  const HomeScreenAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3867D5),
            Color(0xFF81C7F5),
          ],
        ),
      ),
      child: BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
        return Column(
          children: [
            AppBar(
              title: Text(
                  'Hello Brenda!\nToday you have ${(state is TaskLoadedState) ? state.todayCount : 0} tasks'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
              ),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            if (state is TaskLoadedState &&
                state.taskHavedAlert != null &&
                state.showAlert)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  color: Colors.white10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Today reminder',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                            Text(
                              state.taskHavedAlert!.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              DateFormat('hh:mm a')
                                  .format(state.taskHavedAlert!.time),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        Image.asset('assets/images/bell.png'),
                        CircleAvatar(
                          minRadius: 0,
                          backgroundColor: Colors.white12,
                          maxRadius: 15,
                          child: IconButton(
                              onPressed: () {
                                BlocProvider.of<TaskBloc>(context)
                                    .dontShowAlert();
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 15,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
