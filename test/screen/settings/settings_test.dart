import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timer/bloc/add_form/add_form_bloc.dart';
import 'package:timer/bloc/repo/repo_bloc.dart';
import 'package:timer/cubit/duration/duration_cubit.dart';
import 'package:timer/cubit/navigation/navigation_cubit.dart';
import 'package:timer/cubit/navigation/navigation_item.dart';
import 'package:timer/cubit/shift/shift_cubit.dart';
import 'package:timer/cubit/shift/shift_state.dart';
import 'package:timer/model/shift.dart';
import 'package:timer/screen/settings/settings_screen.dart';
import 'package:timer/util/constants.dart' as constants;

import '../../helpers/hydrated_bloc.dart';
import '../../helpers/mocking_classes.dart';

void main() {
  group('screen testing', () {
    late MockNavigationCubit mockNavigationCubit;
    late MockRepoBloc mockRepoBloc;
    late MockShiftCubit mockShiftCubit;
    late MockAddFormBloc mockAddFormBloc;
    late MockDurationCubit mockDurationCubit;
    setUp(() {
      mockNavigationCubit = MockNavigationCubit();
      mockRepoBloc = MockRepoBloc();
      mockShiftCubit = MockShiftCubit();
      mockAddFormBloc = MockAddFormBloc();
      mockDurationCubit = MockDurationCubit();
      when(() => mockDurationCubit.state).thenReturn(8.0);
      when(() => mockDurationCubit.defaultValue).thenReturn(8.0);
    });

    testWidgets('elements exist', (tester) async {
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
      when(() => mockShiftCubit.state).thenReturn(ShiftState(
        shift: Shift(
          start: null,
          end: null,
          duration: const Duration(hours: 8),
        ),
        enabledStart: true,
        enabledEnd: false,
        status: ShiftStateStatus.initial,
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
                  child: BlocProvider<DurationCubit>.value(
                    value: mockDurationCubit,
                    child: const MaterialApp(
                      home: Scaffold(
                        body: SettingsScreen(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });

      final wrench = find.byIcon(Icons.build_sharp);
      expect(wrench, findsOneWidget);

      final add = find.byIcon(Icons.add);
      expect(add, findsOneWidget);

      final list = find.byType(ListView);
      expect(list, findsOneWidget);

      final dropdownMonths = find.byKey(const Key(constants.months));
      expect(dropdownMonths, findsOneWidget);
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
      when(() => mockShiftCubit.state).thenReturn(ShiftState(
        shift: Shift(
          start: null,
          end: null,
          duration: const Duration(hours: 8),
        ),
        enabledStart: true,
        enabledEnd: false,
        status: ShiftStateStatus.initial,
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
                  child: BlocProvider<DurationCubit>.value(
                    value: mockDurationCubit,
                    child: const MaterialApp(
                      home: Scaffold(
                        body: SettingsScreen(),
                      ),
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
        'when list of shifts scroll down then floating action bar should change opacity to invisible = 0',
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
      when(() => mockShiftCubit.state).thenReturn(ShiftState(
        shift: Shift(
          start: null,
          end: null,
          duration: const Duration(hours: 8),
        ),
        enabledStart: true,
        enabledEnd: false,
        status: ShiftStateStatus.initial,
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
                  child: BlocProvider<DurationCubit>.value(
                    value: mockDurationCubit,
                    child: const MaterialApp(
                      home: Scaffold(
                        body: SettingsScreen(),
                      ),
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

      await scrollDown(tester, shiftList);
    });

    testWidgets(
        'when list of shifts scroll up then floating action bar should change opacity from 0 to visible = 1',
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
      when(() => mockShiftCubit.state).thenReturn(ShiftState(
        shift: Shift(
          start: null,
          end: null,
          duration: const Duration(hours: 8),
        ),
        enabledStart: true,
        enabledEnd: false,
        status: ShiftStateStatus.initial,
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
                  child: BlocProvider<DurationCubit>.value(
                    value: mockDurationCubit,
                    child: const MaterialApp(
                      home: Scaffold(
                        body: SettingsScreen(),
                      ),
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

      await scrollDown(tester, shiftList);

      await scrollUp(tester, shiftList);
    });
  });
}

Future<void> scrollDown(WidgetTester tester, Finder shiftList) async {
  await tester.drag(shiftList, const Offset(0.0, -25.0));
  await tester.pumpAndSettle();

  final wrench = find.byKey(const Key(constants.wrenchOpacity));
  expect(wrench, findsOneWidget);

  final add = find.byKey(const Key(constants.addOpacity));
  expect(add, findsOneWidget);

  final AnimatedOpacity wrenchButton = tester.firstWidget(wrench);
  expect(wrenchButton.opacity, equals(0.0));

  final AnimatedOpacity addButton = tester.firstWidget(add);
  expect(addButton.opacity, equals(0.0));
}

Future<void> scrollUp(WidgetTester tester, Finder shiftList) async {
  final wrench = find.byKey(const Key(constants.wrenchOpacity));
  expect(wrench, findsOneWidget);

  final add = find.byKey(const Key(constants.addOpacity));
  expect(add, findsOneWidget);

  await tester.drag(shiftList, const Offset(0.0, 30.0));
  await tester.pumpAndSettle();

  final AnimatedOpacity wrenchButton = tester.firstWidget(wrench);
  expect(wrenchButton.opacity, equals(1.0));

  final AnimatedOpacity addButton = tester.firstWidget(add);
  expect(addButton.opacity, equals(1.0));
}

Type typeOf<T>() => T;
