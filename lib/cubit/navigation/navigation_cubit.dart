import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timer/cubit/navigation/navigation_item.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit()
      : super(const NavigationState(navbarItem: NavbarItem.home, index: 0));

  void changeNavbarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.home:
        emit(const NavigationState(navbarItem: NavbarItem.home, index: 0));
        break;
      case NavbarItem.settings:
        emit(const NavigationState(navbarItem: NavbarItem.settings, index: 1));
        break;
      case NavbarItem.statistics:
        emit(
            const NavigationState(navbarItem: NavbarItem.statistics, index: 2));
        break;
      default:
        emit(const NavigationState(navbarItem: NavbarItem.home, index: 0));
    }
  }
}
