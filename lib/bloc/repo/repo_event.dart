part of 'repo_bloc.dart';

abstract class RepoEvent extends Equatable {
  const RepoEvent();

  @override
  List<Object> get props => [];
}

class RepoSubscriptionRequested extends RepoEvent {}

class RepoShiftSaved extends RepoEvent {
  final Shift shift;

  const RepoShiftSaved(this.shift);
}

class RepoReset extends RepoEvent {}
