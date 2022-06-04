import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timer/bloc/add_form/add_form_bloc.dart';
import 'package:timer/bloc/repo/repo_bloc.dart';
import 'package:timer/cubit/duration/duration_cubit.dart';
import 'package:timer/cubit/navigation/navigation_cubit.dart';
import 'package:timer/cubit/shift/shift_cubit.dart';
import 'package:timer/cubit/shift/shift_state.dart';
import 'package:timer/repository/shift_api.dart';
import 'package:timer/shift_box.dart';

class MockNavigationCubit extends MockCubit<NavigationState>
    implements NavigationCubit {}

class MockRepoBloc extends MockCubit<RepoState> implements RepoBloc {}

class MockShiftCubit extends MockCubit<ShiftState> implements ShiftCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockAddFormBloc extends MockCubit<AddFormState> implements AddFormBloc {}

class MockDurationCubit extends MockCubit<double> implements DurationCubit {}

class MockShiftBox extends Mock implements ShiftBox {}

class MockBox<T> extends Mock implements Box<T> {}

class MockShiftApi extends Mock implements ShiftApi {}
