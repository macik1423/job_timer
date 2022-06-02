import 'package:bloc/bloc.dart';

class DurationCubit extends Cubit<double> {
  late double defaultValue = 8.0;

  DurationCubit() : super(8.0);

  void changeValue(double value) {
    emit(value);
  }

  void resetToDefault() {
    emit(defaultValue);
  }

  void changeDefaultValue(double value) {
    defaultValue = value;
  }
}
