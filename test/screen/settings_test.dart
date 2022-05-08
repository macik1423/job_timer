import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timer/bloc/add_form/add_form_bloc.dart';
import 'package:timer/bloc/repo/repo_bloc.dart';
import 'package:timer/cubit/navigation/navigation_cubit.dart';
import 'package:timer/cubit/navigation/navigation_item.dart';
import 'package:timer/cubit/shift/shift_cubit.dart';
import 'package:timer/cubit/shift/shift_state.dart';
import 'package:timer/model/shift.dart';
import 'package:timer/screen/settings/settings_screen.dart';

import '../helpers/hydrated_bloc.dart';
import 'navigation_panel_test.dart';

void main() {
  group('screen testing', () {
    late MockNavigationCubit mockNavigationCubit;
    late MockRepoBloc mockRepoBloc;
    late MockShiftCubit mockShiftCubit;
    late MockAddFormBloc mockAddFormBloc;
    setUp(() {
      mockNavigationCubit = MockNavigationCubit();
      mockRepoBloc = MockRepoBloc();
      mockShiftCubit = MockShiftCubit();
      mockAddFormBloc = MockAddFormBloc();
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
          ),
        ),
        status: RepoStateStatus.success,
      ));
      when(() => mockShiftCubit.state).thenReturn(InitialShiftState(
        shift: Shift(
          start: null,
          end: null,
        ),
        enabledStart: true,
        enabledEnd: false,
      ));

      await mockHydratedStorage(() async {
        await tester.pumpWidget(
          BlocProvider<ShiftCubit>.value(
            value: mockShiftCubit,
            child: BlocProvider<RepoBloc>.value(
              value: mockRepoBloc,
              child: BlocProvider<NavigationCubit>.value(
                value: mockNavigationCubit,
                child: BlocProvider<AddFormBloc>.value(
                  value: mockAddFormBloc,
                  child: const MaterialApp(
                    home: Scaffold(
                      body: SettingsScreen(),
                    ),
                  ),
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

    testWidgets(
        'when scroll down list of shifts then floating action bar should change opacity',
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
          ),
        ),
        status: RepoStateStatus.success,
      ));
      when(() => mockShiftCubit.state).thenReturn(InitialShiftState(
        shift: Shift(
          start: null,
          end: null,
        ),
        enabledStart: true,
        enabledEnd: false,
      ));

      await mockHydratedStorage(() async {
        await tester.pumpWidget(
          BlocProvider<ShiftCubit>.value(
            value: mockShiftCubit,
            child: BlocProvider<RepoBloc>.value(
              value: mockRepoBloc,
              child: BlocProvider<NavigationCubit>.value(
                value: mockNavigationCubit,
                child: BlocProvider<AddFormBloc>.value(
                  value: mockAddFormBloc,
                  child: const MaterialApp(
                    home: Scaffold(
                      body: SettingsScreen(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });

      final shiftList = find.byType(ListView);
      await tester.ensureVisible(shiftList);
      await tester.pumpAndSettle();

      await tester.drag(shiftList, const Offset(0.0, -200.0));
      await tester.pumpAndSettle();

      final finder = find.byType(AnimatedOpacity);
      expect(finder, findsOneWidget);

      final AnimatedOpacity button = tester.firstWidget(finder);
      expect(button.opacity, equals(0.0));
    });
  });
}

Type typeOf<T>() => T;
