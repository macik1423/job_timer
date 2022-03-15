part of 'repo_bloc.dart';

enum RepoStateStatus { initial, loading, success, failure }

class RepoState {
  final RepoStateStatus status;
  final List<Shift> shifts;
  final String message;

  const RepoState({
    this.status = RepoStateStatus.initial,
    this.shifts = const [],
    this.message = "",
  });

  RepoState copyWith({
    RepoStateStatus? status,
    List<Shift>? shifts,
    String? message,
  }) {
    return RepoState(
      status: status ?? this.status,
      shifts: shifts ?? this.shifts,
      message: message ?? this.message,
    );
  }
}
