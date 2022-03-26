part of 'add_form_bloc.dart';

abstract class AddFormEvent extends Equatable {
  const AddFormEvent();

  @override
  List<Object> get props => [];
}

class ShiftInputChanged extends AddFormEvent {
  final ShiftInput input;

  const ShiftInputChanged(this.input);

  @override
  List<Object> get props => [input];
}
