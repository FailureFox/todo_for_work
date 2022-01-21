abstract class HomeState {
  const HomeState();
}

class HomeInitialState extends HomeState {
  const HomeInitialState();
}

class HomeWelcomeState extends HomeState {}

class HomeLoadedState extends HomeState {
  final String name;
  final int page;
  HomeLoadedState({required this.name, this.page = 0});
  HomeLoadedState copyWith({String? name, int? page}) {
    return HomeLoadedState(name: name ?? this.name, page: page ?? this.page);
  }
}
