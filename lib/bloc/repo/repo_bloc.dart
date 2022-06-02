import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timer/repository/shift_repository.dart';

import '../../model/shift.dart';

part 'repo_event.dart';
part 'repo_state.dart';

class RepoBloc extends Bloc<RepoEvent, RepoState> {
  RepoBloc(ShiftRepository shiftRepository)
      : _shiftRepository = shiftRepository,
        super(const RepoState()) {
    on<RepoSubscriptionRequested>(_getShifts);
    on<RepoShiftSaved>(_saveShift);
    on<RepoReset>(_reset);
    on<RepoShiftDeleted>(_deleteShift);
  }

  final ShiftRepository _shiftRepository;

  void _reset(RepoReset event, Emitter<RepoState> emit) {
    emit(state.copyWith(status: RepoStateStatus.success));
  }

  Future<void> _getShifts(
      RepoSubscriptionRequested event, Emitter<RepoState> emit) async {
    emit(state.copyWith(status: RepoStateStatus.loading));

    await emit.forEach<List<Shift>>(
      _shiftRepository.getShifts(),
      onData: (shifts) => state.copyWith(
        status: RepoStateStatus.success,
        shifts: shifts,
      ),
      onError: (_, __) => state.copyWith(
        status: RepoStateStatus.failure,
      ),
    );
  }

  Future<void> _saveShift(RepoShiftSaved event, Emitter<RepoState> emit) async {
    try {
      await _shiftRepository.saveShift(event.shift);
      emit(
        state.copyWith(
          status: RepoStateStatus.success,
        ),
      );
    } on Exception catch (error) {
      emit(
        state.copyWith(
          status: RepoStateStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  FutureOr<void> _deleteShift(
      RepoShiftDeleted event, Emitter<RepoState> emit) async {
    await _shiftRepository.deleteShift(event.shift);
    emit(state.copyWith(status: RepoStateStatus.success));
  }
}
