import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timer/bloc/repo/repo_bloc.dart';
import 'package:timer/cubit/navigation/navigation_cubit.dart';
import 'package:timer/cubit/navigation/navigation_item.dart';
import 'package:timer/cubit/shift/shift_cubit.dart';
import 'package:timer/cubit/shift/shift_state.dart';
import 'package:timer/model/shift.dart';
import 'package:timer/screen/root_screen.dart';

import 'helpers/hydrated_bloc.dart';

class MockNavigationCubit extends MockCubit<NavigationState>
    implements NavigationCubit {}

class MockRepoBloc extends MockCubit<RepoState> implements RepoBloc {}

class MockShiftCubit extends MockCubit<ShiftState> implements ShiftCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('button is present and triggers navigation after tapped', () {
    late MockNavigationCubit mockNavigationCubit;
    late MockRepoBloc mockRepoBloc;
    late MockShiftCubit mockShiftCubit;
    setUp(() {
      mockNavigationCubit = MockNavigationCubit();
      mockRepoBloc = MockRepoBloc();
      mockShiftCubit = MockShiftCubit();
    });

    testWidgets('home', (tester) async {
      when(() => mockNavigationCubit.state).thenReturn(
          const NavigationState(navbarItem: NavbarItem.home, index: 0));
      when(() => mockRepoBloc.state).thenReturn(const RepoState());
      when(() => mockShiftCubit.state).thenReturn(InitialShiftState(
        shift: Shift(
          start: null,
          end: null,
        ),
        enabledStart: true,
        enabledEnd: false,
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
      });
    });
  });
}
