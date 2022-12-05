class AppGeneralException implements Exception {
  String cause;
  AppGeneralException(this.cause);
  @override
  String toString() => cause;
}
