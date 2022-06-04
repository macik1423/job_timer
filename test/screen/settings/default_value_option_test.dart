import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
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
import 'package:timer/screen/settings/default_value_option.dart';
import 'package:timer/screen/settings/settings_screen.dart';

import '../../helpers/hydrated_bloc.dart';
import '../../helpers/mocking_classes.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

void main() {
  group('test switching default duration', () {
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
      when(() => mockAddFormBloc.state).thenReturn(const AddFormState(
        shift: AddShiftTime.pure(),
        date: AddShiftDate.pure(),
        status: FormzStatus.pure,
      ));
    });

    testWidgets('should open change duration option', (tester) async {
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

      await tester.tap(wrench);
      await tester.pumpAndSettle();

      final defaultValueOption = find.byType(DefaultValueOption);
      expect(defaultValueOption, findsOneWidget);
    });

    testWidgets('should change default value and save', (tester) async {
      await mockHydratedStorage(() async {
        await tester.pumpWidget(
          BlocProvider<RepoBloc>.value(
            value: mockRepoBloc,
            child: BlocProvider<AddFormBloc>.value(
              value: mockAddFormBloc,
              child: BlocProvider<DurationCubit>.value(
                value: mockDurationCubit,
                child: MaterialApp(
                  home: const Scaffold(
                    body: SettingsScreen(),
                  ),
                  routes: <String, WidgetBuilder>{
                    '/DefaultValueOption': (BuildContext context) =>
                        const DefaultValueOption(),
                  },
                ),
              ),
            ),
          ),
        );
      });

      final wrench = find.byIcon(Icons.build_sharp);
      expect(wrench, findsOneWidget);

      await tester.tap(wrench);
      await tester.pumpAndSettle();

      final defaultValueOption = find.byType(DefaultValueOption);
      expect(defaultValueOption, findsOneWidget);

      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      final Slider sliderWidget = tester.widget(slider);
      sliderWidget.onChanged!(10.0);
      await tester.pumpAndSettle();

      final text = find.text("10 h");
      expect(text, findsOneWidget);

      final saveButton = find.byType(ElevatedButton);
      expect(saveButton, findsOneWidget);

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      final snackbar = find.byType(SnackBar);
      expect(snackbar, findsOneWidget);
    });
  });
}
