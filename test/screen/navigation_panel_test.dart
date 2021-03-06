import 'package:bloc_test/bloc_test.dart';
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
import 'package:timer/screen/root_screen.dart';
import 'package:timer/util/constants.dart' as constants;

import '../helpers/hydrated_bloc.dart';

class MockNavigationCubit extends MockCubit<NavigationState>
    implements NavigationCubit {}

class MockRepoBloc extends MockCubit<RepoState> implements RepoBloc {}

class MockShiftCubit extends MockCubit<ShiftState> implements ShiftCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockAddFormBloc extends MockCubit<AddFormState> implements AddFormBloc {}

class MockDurationCubit extends MockCubit<double> implements DurationCubit {}

void main() {
  group('test bottom navigation icons', () {
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

    testWidgets('navigate to home', (tester) async {
      when(() => mockNavigationCubit.state).thenReturn(
          const NavigationState(navbarItem: NavbarItem.home, index: 0));
      when(() => mockRepoBloc.state).thenReturn(const RepoState());
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
      final icon = find.byIcon(Icons.home);
      await mockHydratedStorage(() async {
        await tester.pumpWidget(
          BlocProvider<ShiftCubit>.value(
            value: mockShiftCubit,
            child: BlocProvider<RepoBloc>.value(
              value: mockRepoBloc,
              child: BlocProvider<NavigationCubit>.value(
                value: mockNavigationCubit,
                child: BlocProvider<DurationCubit>.value(
                  value: mockDurationCubit,
                  child: const MaterialApp(
                    home: Scaffold(
                      body: RootScreen(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(icon, findsOneWidget);
        await tester.tap(icon);
        await tester.pump();
        expect(find.text(constants.inn), findsWidgets);
      });
    });

    testWidgets('navigate to settings', (tester) async {
      when(() => mockAddFormBloc.state).thenReturn(const AddFormState());
      when(() => mockNavigationCubit.state).thenReturn(
          const NavigationState(navbarItem: NavbarItem.home, index: 0));
      when(() => mockRepoBloc.state)
          .thenReturn(const RepoState(status: RepoStateStatus.success));
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
      when(() => mockNavigationCubit.state).thenReturn(
          const NavigationState(navbarItem: NavbarItem.settings, index: 1));
      final icon = find.byIcon(Icons.settings);

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
                        body: RootScreen(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(icon, findsOneWidget);
        await tester.ensureVisible(icon);
        await tester.tap(icon);
        await tester.pumpAndSettle();

        expect(find.text(constants.inn), findsOneWidget);
        expect(find.byKey(const Key(constants.months)), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
      });
    });

    testWidgets('navigate to stats', (tester) async {
      when(() => mockNavigationCubit.state).thenReturn(
          const NavigationState(navbarItem: NavbarItem.home, index: 0));
      when(() => mockRepoBloc.state).thenReturn(const RepoState());
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
      when(() => mockNavigationCubit.state).thenReturn(
          const NavigationState(navbarItem: NavbarItem.statistics, index: 2));
      final icon = find.byIcon(Icons.stacked_bar_chart_sharp);
      await mockHydratedStorage(() async {
        await tester.pumpWidget(
          BlocProvider<ShiftCubit>.value(
            value: mockShiftCubit,
            child: BlocProvider<RepoBloc>.value(
              value: mockRepoBloc,
              child: BlocProvider<NavigationCubit>.value(
                value: mockNavigationCubit,
                child: const MaterialApp(
                  home: Scaffold(
                    body: RootScreen(),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(icon, findsOneWidget);
        await tester.ensureVisible(icon);
        await tester.tap(icon);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key(constants.months)), findsOneWidget);
        expect(find.byKey(const Key(constants.summary)), findsOneWidget);
        expect(find.byKey(const Key(constants.chart)), findsOneWidget);
      });
    });
  });
}
