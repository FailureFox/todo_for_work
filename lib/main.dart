import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/blocs/app_bloc/app_bloc.dart';
import 'package:todo_app/blocs/app_bloc/app_state.dart';
import 'package:todo_app/blocs/tasks_bloc/task_cubit.dart';
import 'package:todo_app/data/domain/tasks_domain.dart';
import 'package:todo_app/data/domain/tasks_repository.dart';
import 'package:todo_app/ui/screens/home_screen.dart';
import 'package:todo_app/ui/screens/onboarding.dart';
import 'package:path_provider/path_provider.dart' as path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory? dir = await path.getExternalStorageDirectory();
  Hive.init(dir!.path);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeInheritedWidget(
      bloc: HomeBloc(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const _LandingPage()),
    );
  }
}

class _LandingPage extends StatelessWidget {
  const _LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        bloc: HomeInheritedWidget.of(context)!.bloc,
        builder: (context, state) {
          if (state is HomeLoadedState) {
            return BlocProvider<TaskBloc>(
                create: (_) => TaskBloc(
                    taskDomain: TasksDomain(),
                    taskRepository: const TaskRepository()),
                child: const HomeScreen());
          } else if (state is HomeWelcomeState) {
            return const OnBoarding();
          } else {
            return Container(
              color: Colors.white,
            );
          }
        });
  }
}

class HomeInheritedWidget extends InheritedWidget {
  final HomeBloc bloc;
  const HomeInheritedWidget({Key? key, required this.child, required this.bloc})
      : super(key: key, child: child);

  final Widget child;

  static HomeInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeInheritedWidget>();
  }

  @override
  bool updateShouldNotify(HomeInheritedWidget oldWidget) {
    return false;
  }
}
