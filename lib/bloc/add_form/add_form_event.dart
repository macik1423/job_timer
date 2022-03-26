part of 'add_form_bloc.dart';

abstract class AddFormEvent extends Equatable {
  const AddFormEvent();

  @override
  List<Object> get props => [];
}

class ShiftTimeInputChanged extends AddFormEvent {
  final ShiftTimeInput input;

  const ShiftTimeInputChanged(this.input);

  @override
  List<Object> get props => [input];
}

class ShiftDateInputChanged extends AddFormEvent {
  final ShiftDateInput input;

  const ShiftDateInputChanged(this.input);

  @override
  List<Object> get props => [input];
}
