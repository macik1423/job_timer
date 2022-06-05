import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timer/bloc/repo/repo_bloc.dart';
import 'package:timer/cubit/navigation/navigation_cubit.dart';
import 'package:timer/cubit/navigation/navigation_item.dart';
import 'package:timer/model/shift.dart';
import 'package:timer/screen/statistics/chart.dart';
import 'package:timer/screen/statistics/statistics_screen.dart';
import 'package:timer/util/constants.dart' as constants;

import '../helpers/hydrated_bloc.dart';
import 'navigation_panel_test.dart';

void main() {
  group('screen testing', () {
    late MockNavigationCubit mockNavigationCubit;
    late MockRepoBloc mockRepoBloc;
    setUp(() {
      mockNavigationCubit = MockNavigationCubit();
      mockRepoBloc = MockRepoBloc();
    });

    testWidgets('display positive result properly', (tester) async {
      final yearNow = DateTime.now().year;
      final month = DateTime.now().month;
      when(() => mockNavigationCubit.state).thenReturn(
          const NavigationState(navbarItem: NavbarItem.statistics, index: 2));
      when(() => mockRepoBloc.state).thenReturn(RepoState(
        shifts: List<Shift>.generate(
          30,
          (_) => Shift(
            start: DateTime(yearNow, month, 1, 1, 0, 0),
            end: DateTime(yearNow, month, 1, 10, 0, 0),
            duration: const Duration(hours: 8),
          ),
        ),
        status: RepoStateStatus.success,
      ));

      await mockHydratedStorage(() async {
        await tester.pumpWidget(
          BlocProvider<RepoBloc>.value(
            value: mockRepoBloc,
            child: BlocProvider<NavigationCubit>.value(
              value: mockNavigationCubit,
              child: const MaterialApp(
                home: Scaffold(
                  body: StatisticsScreen(),
                ),
              ),
            ),
          ),
        );
      });

      final dropdown = find.byKey(const Key(constants.months));
      expect(dropdown, findsOneWidget);

      final chart = find.byType(Chart);
      expect(chart, findsOneWidget);

      final summary = find.byKey(const Key(constants.summary));
      expect(summary, findsOneWidget);

      final plus = find.byIcon(Icons.add);
      expect(plus, findsOneWidget);
    });

    testWidgets('display negative result properly', (tester) async {
      final yearNow = DateTime.now().year;
      final month = DateTime.now().month;
      when(() => mockNavigationCubit.state).thenReturn(
          const NavigationState(navbarItem: NavbarItem.statistics, index: 2));
      when(() => mockRepoBloc.state).thenReturn(RepoState(
        shifts: List<Shift>.generate(
          30,
          (_) => Shift(
            start: DateTime(yearNow, month, 1, 1, 0, 0),
            end: DateTime(yearNow, month, 1, 7, 0, 0),
            duration: const Duration(hours: 8),
          ),
        ),
        status: RepoStateStatus.success,
      ));

      await mockHydratedStorage(() async {
        await tester.pumpWidget(
          BlocProvider<RepoBloc>.value(
            value: mockRepoBloc,
            child: BlocProvider<NavigationCubit>.value(
              value: mockNavigationCubit,
              child: const MaterialApp(
                home: Scaffold(
                  body: StatisticsScreen(),
                ),
              ),
            ),
          ),
        );
      });

      final dropdown = find.byKey(const Key(constants.months));
      expect(dropdown, findsOneWidget);

      final chart = find.byType(Chart);
      expect(chart, findsOneWidget);

      final summary = find.byKey(const Key(constants.summary));
      expect(summary, findsOneWidget);

      final plus = find.byIcon(Icons.remove);
      expect(plus, findsOneWidget);
    });

    testWidgets('when tap the dropdown button then should find the month',
        (tester) async {
      final yearNow = DateTime.now().year;
      final month = DateTime.now().month;
      when(() => mockNavigationCubit.state).thenReturn(
          const NavigationState(navbarItem: NavbarItem.settings, index: 1));
      when(() => mockRepoBloc.state).thenReturn(RepoState(
        shifts: List<Shift>.generate(
          30,
          (i) => Shift(
            start: DateTime(yearNow, month, 1, 1, i, 0),
            end: DateTime(yearNow, month, 1, 9, i, 0),
            duration: const Duration(hours: 8),
          ),
        ),
        status: RepoStateStatus.success,
      ));

      await mockHydratedStorage(() async {
        await tester.pumpWidget(
          BlocProvider<RepoBloc>.value(
            value: mockRepoBloc,
            child: BlocProvider<NavigationCubit>.value(
              value: mockNavigationCubit,
              child: const MaterialApp(
                home: Scaffold(
                  body: StatisticsScreen(),
                ),
              ),
            ),
          ),
        );
      });

      final dropDownButton = find.byType(typeOf<DropdownButton<String>>());
      await tester.ensureVisible(dropDownButton);
      expect(dropDownButton, findsOneWidget);

      final months = find.byType(typeOf<DropdownMenuItem<String>>());
      expect(months, findsNWidgets(12));
    });
  });
}

Type typeOf<T>() => T;
