import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timer/bloc/repo/repo_bloc.dart';
import 'package:timer/cubit/duration/duration_cubit.dart';
import 'package:timer/cubit/navigation/navigation_cubit.dart';
import 'package:timer/cubit/navigation/navigation_item.dart';
import 'package:timer/cubit/shift/shift_cubit.dart';
import 'package:timer/cubit/shift/shift_state.dart';
import 'package:timer/model/shift.dart';
import 'package:timer/screen/home/home.dart';
import 'package:timer/util/constants.dart' as constants;
import 'package:timer/widgets/duration_modifier.dart';
import 'package:timer/widgets/shift_card.dart';
import 'package:timer/widgets/shifts_list.dart';

import '../helpers/hydrated_bloc.dart';

class MockNavigationCubit extends MockCubit<NavigationState>
    implements NavigationCubit {}

class MockRepoBloc extends MockCubit<RepoState> implements RepoBloc {}

class MockShiftCubit extends MockCubit<ShiftState> implements ShiftCubit {}

class MockDurationCubit extends MockCubit<double> implements DurationCubit {}

void main() {
  group('screen testing', () {
    late MockNavigationCubit mockNavigationCubit;
    late MockRepoBloc mockRepoBloc;
    late MockShiftCubit mockShiftCubit;
    late MockDurationCubit mockDurationCubit;
    setUp(() {
      mockNavigationCubit = MockNavigationCubit();
      mockRepoBloc = MockRepoBloc();
      mockShiftCubit = MockShiftCubit();
      mockDurationCubit = MockDurationCubit();
      when(() => mockDurationCubit.state).thenReturn(8.0);
      when(() => mockDurationCubit.defaultValue).thenReturn(8.0);
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
                  child: BlocProvider<DurationCubit>.value(
                    value: mockDurationCubit,
                    child: const MaterialApp(
                      home: Scaffold(
                        body: Home(),
                      ),
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

    testWidgets('tapped in', (tester) async {
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
                  child: BlocProvider<DurationCubit>.value(
                    value: mockDurationCubit,
                    child: const MaterialApp(
                      home: Scaffold(
                        body: Home(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

      final inButton = find.byKey(const Key(constants.inText));
      expect(inButton, findsOneWidget);
      final outButton = find.byKey(const Key(constants.outText));
      expect(outButton, findsOneWidget);

      final inButtonWidget = tester.widget<ShiftCard>(inButton);
      expect(inButtonWidget.color, Colors.green[300]);
      expect(inButtonWidget.enabled, true);

      final outButtonWidget = tester.widget<ShiftCard>(outButton);
      expect(outButtonWidget.color, Colors.grey[400]);
      expect(outButtonWidget.enabled, false);
      await tester.tap(inButton);
      await tester.pumpAndSettle();

      verify(() => mockShiftCubit.updateStart(any())).called(1);
    });

    testWidgets('tapped out', (tester) async {
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
          start: DateTime(yearNow, month, 1, 1, 0, 0),
          end: DateTime(yearNow, month, 1, 9, 0, 0),
          duration: const Duration(hours: 8),
        ),
        enabledStart: false,
        enabledEnd: true,
        status: ShiftStateStatus.startTapped,
      ));
      when(() => mockDurationCubit.state).thenReturn(8.0);

      await mockHydratedStorage(
        () async {
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
                        body: Home(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

      final inButton = find.byKey(const Key(constants.inText));
      expect(inButton, findsOneWidget);
      final outButton = find.byKey(const Key(constants.outText));
      expect(outButton, findsOneWidget);
      final slider = find.byType(DurationModifier);
      expect(slider, findsOneWidget);

      final inButtonWidget = tester.widget<ShiftCard>(inButton);
      expect(inButtonWidget.color, Colors.grey[400]);
      expect(inButtonWidget.enabled, false);

      final outButtonWidget = tester.widget<ShiftCard>(outButton);
      expect(outButtonWidget.color, Colors.green[300]);
      expect(outButtonWidget.enabled, true);

      await tester.tap(outButton);
      await tester.pumpAndSettle();

      verify(() => mockShiftCubit.updateEnd(any(), any())).called(1);
    });
  });
}
