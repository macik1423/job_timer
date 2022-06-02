import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timer/bloc/repo/repo_bloc.dart';
import 'package:timer/model/shift.dart';
import 'package:timer/repository/shift_repository.dart';

import '../helpers/hydrated_bloc.dart';

class MockShiftRepository extends Mock implements ShiftRepository {}

void main() {
  group('RepoBloc', () {
    late MockShiftRepository mockShiftRepository;
    late Shift shift;
    late Shift newShift;
    setUp(() async {
      mockShiftRepository = MockShiftRepository();
      shift = Shift(
        start: DateTime(2020, 1, 1, 10, 0),
        end: DateTime(2020, 1, 1, 12, 0),
      );
      newShift = Shift(
        start: DateTime(2020, 1, 1, 11, 0),
        end: DateTime(2020, 1, 1, 12, 0),
      );
      when(() => mockShiftRepository.saveShift(newShift))
          .thenAnswer((invocation) => Future.value());
      when(() => mockShiftRepository
        ..saveShift(shift)
        ..saveShift(shift)).thenAnswer((invocation) => throw Exception());
      when(() => mockShiftRepository.deleteShift(newShift))
          .thenAnswer((invocation) => Future.value());
    });

    test('initial state is correct', () async {
      await mockHydratedStorage(() {
        expect(
          const RepoState().status,
          RepoStateStatus.initial,
        );
      });
    });

    group('save shift', () {
      blocTest<RepoBloc, RepoState>(
        'properly save',
        build: () => RepoBloc(mockShiftRepository),
        act: (bloc) => bloc.add(RepoShiftSaved(newShift)),
        expect: () =>
            <RepoState>[const RepoState(status: RepoStateStatus.success)],
      );
      blocTest<RepoBloc, RepoState>(
        'throw exception',
        build: () => RepoBloc(mockShiftRepository),
        act: (bloc) => bloc
          ..add(RepoShiftSaved(shift))
          ..add(RepoShiftSaved(shift)),
        expect: () => <RepoState>[
          const RepoState(status: RepoStateStatus.failure, message: 'Exception')
        ],
      );
    });

    group('delete shift', () {
      blocTest<RepoBloc, RepoState>(
        'properly delete',
        build: () => RepoBloc(mockShiftRepository),
        act: (bloc) => bloc.add(RepoShiftDeleted(newShift)),
        expect: () =>
            <RepoState>[const RepoState(status: RepoStateStatus.success)],
      );
    });
  });
}
