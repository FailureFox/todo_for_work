import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/blocs/app_bloc/app_state.dart';

class HomeBloc extends Cubit<HomeState> {
  late SharedPreferences prefs;
  HomeBloc() : super(const HomeInitialState()) {
    isFirst();
  }
  void homeLoading() {
    emit(HomeLoadedState(name: ''));
  }

  Future<void> isFirst() async {
    prefs = await SharedPreferences.getInstance();
    final isFirst = prefs.getBool('isFirst') ?? true;
    if (isFirst) {
      emit(HomeWelcomeState());
      prefs.setBool('isFirst', false);
    } else {
      final name = prefs.getString('name') ?? '';
      emit(HomeLoadedState(name: name));
    }
  }

  void changePage(int value) {
    emit((state as HomeLoadedState).copyWith(page: value));
  }
}
