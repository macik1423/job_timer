import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/screen/home/home.dart';
import 'package:timer/screen/settings/settings.dart';
import 'package:timer/screen/statistics/statistics.dart';

import '../cubit/navigation/navigation_cubit.dart';
import '../cubit/navigation/navigation_item.dart';
import '../util/constants.dart' as constants;

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state.index,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: constants.dashboardText,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: constants.settingsText,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.stacked_bar_chart_sharp,
                ),
                label: constants.statsText,
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  context
                      .read<NavigationCubit>()
                      .changeNavbarItem(NavbarItem.home);
                  break;
                case 1:
                  context
                      .read<NavigationCubit>()
                      .changeNavbarItem(NavbarItem.settings);
                  break;
                case 2:
                  context
                      .read<NavigationCubit>()
                      .changeNavbarItem(NavbarItem.statistics);
                  break;
                default:
                  context
                      .read<NavigationCubit>()
                      .changeNavbarItem(NavbarItem.home);
                  break;
              }
            },
          );
        },
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          switch (state.navbarItem) {
            case NavbarItem.home:
              return const Home();
            case NavbarItem.settings:
              return const Settings();
            case NavbarItem.statistics:
              return const Statistics();
            default:
              return const Home();
          }
        },
      ),
    );
  }
}
