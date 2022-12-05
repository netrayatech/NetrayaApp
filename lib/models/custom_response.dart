class CustomResponse {
  final String errorCode;
  final dynamic message;

  CustomResponse({required this.errorCode, required this.message});

  static CustomResponse fromMap(Map<String, dynamic> map) {
    return CustomResponse(errorCode: map['errorCode'], message: map['message']);
  }
}

class ApiErrorCode {
  static const String SUCCESS = 'NTA-1-000';
  static const String DATA_NOT_FOUND = 'NTA-2-404';
}
