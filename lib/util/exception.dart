class ShiftAlreadyExistsException implements Exception {
  final String message;
  ShiftAlreadyExistsException(this.message) : super();

  @override
  String toString() {
    return message;
  }
}
