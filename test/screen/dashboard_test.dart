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
import 'package:timer/screen/home/home.dart';
import 'package:timer/util/constants.dart' as constants;
import 'package:timer/widgets/shifts_list.dart';

import '../helpers/hydrated_bloc.dart';
import 'navigation_panel_test.dart';

void main() {
  group('screen testing', () {
    late MockNavigationCubit mockNavigationCubit;
    late MockRepoBloc mockRepoBloc;
    late MockShiftCubit mockShiftCubit;
    setUp(() {
      mockNavigationCubit = MockNavigationCubit();
      mockRepoBloc = MockRepoBloc();
      mockShiftCubit = MockShiftCubit();
    });

    testWidgets('home view', (tester) async {
      final yearNow = DateTime.now().year;
      final month = DateTime.now().month;
      when(() => mockNavigationCubit.state).thenReturn(
          const NavigationState(navbarItem: NavbarItem.home, index: 0));
      when(() => mockRepoBloc.state).thenReturn(RepoState(
        shifts: List<Shift>.generate(
          5,
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

      await mockHydratedStorage(
        () async {
          await tester.pumpWidget(
            BlocProvider<ShiftCubit>.value(
              value: mockShiftCubit,
              child: BlocProvider<RepoBloc>.value(
                value: mockRepoBloc,
                child: BlocProvider<NavigationCubit>.value(
                  value: mockNavigationCubit,
                  child: const MaterialApp(
                    home: Scaffold(
                      body: Home(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
      final shiftList = find.byType(ShiftsList);
      expect(shiftList, findsOneWidget);

      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      final inButton = find.byKey(const Key(constants.inText));
      expect(inButton, findsOneWidget);

      final outButton = find.byKey(const Key(constants.outText));
      expect(outButton, findsOneWidget);

      final mainClock = find.byKey(const Key(constants.mainClockText));
      expect(mainClock, findsOneWidget);
    });
  });
}
