part of 'add_form_bloc.dart';

class AddFormState extends Equatable {
  final AddShift shift;
  final FormzStatus status;

  const AddFormState({
    this.shift = const AddShift.pure(),
    this.status = FormzStatus.pure,
  });

  AddFormState copyWith({
    AddShift? shift,
    FormzStatus? status,
  }) {
    return AddFormState(
      shift: shift ?? this.shift,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [shift, status];
}
