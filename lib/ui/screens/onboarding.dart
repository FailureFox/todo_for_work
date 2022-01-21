import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/app_bloc/app_bloc.dart';
import 'package:todo_app/blocs/app_bloc/app_state.dart';
import 'package:todo_app/blocs/tasks_bloc/task_cubit.dart';
import 'package:todo_app/data/domain/tasks_domain.dart';
import 'package:todo_app/data/domain/tasks_repository.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/ui/screens/home_screen.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Spacer(flex: 3),
            OnBoardingLogo(),
            Spacer(),
            Text(AppTexts.welcomeTitle, style: AppStyles.titleTextStyle),
            Spacer(flex: 2),
            WelcomeNextButton(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class OnBoardingLogo extends StatelessWidget {
  const OnBoardingLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppImages.logo);
  }
}

class WelcomeNextButton extends StatelessWidget {
  const WelcomeNextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      clipBehavior: Clip.hardEdge,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(0),
      ),
      onPressed: () {
        HomeInheritedWidget.of(context)!.bloc.homeLoading();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => BlocProvider(
                    create: (_) => TaskBloc(
                        taskDomain: TasksDomain(),
                        taskRepository: const TaskRepository()),
                    child: const HomeScreen())),
            (route) => false);
      },
      child: Container(
        height: MediaQuery.of(context).size.width / 7,
        width: MediaQuery.of(context).size.width / 1.4,
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFF5DE61A), Color(0xFF39A801)])),
        child: const Center(
          child: Text('Get started', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class AppImages {
  static const String path = 'assets/images';
  static const String logo = '$path/logo.png';
  static const String emptyTasks = '$path/empty_tasks.png';
}

class AppColors {
  static const Color titleTextColor = Color(0xFF554E8F);
}

class AppTexts {
  static const welcomeTitle = 'Reminders made simple';
}

class AppStyles {
  static const titleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.titleTextColor,
  );
}
