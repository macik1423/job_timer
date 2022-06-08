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
import 'package:timer/model/add_form/add_shift.dart';
import 'package:timer/model/shift.dart';
import 'package:timer/screen/settings/add_form.dart';
import 'package:timer/screen/settings/settings_screen.dart';
import 'package:timer/util/constants.dart' as constants;
import 'package:timer/widgets/duration_modifier.dart';

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

    testWidgets('should open add form', (tester) async {
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
      when(() => mockAddFormBloc.state).thenReturn(AddFormState(
        time: const AddShiftTime.pure(),
        date: const AddShiftDate.pure(),
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

      final addButton = find.byIcon(Icons.add);
      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      final addForm = find.byType(AddForm);
      expect(addForm, findsOneWidget);
    });

    testWidgets('elements exists', (tester) async {
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
      when(() => mockAddFormBloc.state).thenReturn(AddFormState(
        time: const AddShiftTime.pure(),
        date: const AddShiftDate.pure(),
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
                        body: AddForm(
                          month: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });

      final inLabelText = find.byKey(const Key(constants.inn));
      expect(inLabelText, findsOneWidget);

      final outLabelText = find.byKey(const Key(constants.out));
      expect(outLabelText, findsOneWidget);

      final dayLabelText = find.byKey(const Key(constants.day));
      expect(dayLabelText, findsOneWidget);

      final slider = find.byType(DurationModifier);
      expect(slider, findsOneWidget);

      final addButton = find.byType(ElevatedButton);
      expect(addButton, findsOneWidget);
    });
  });
}
