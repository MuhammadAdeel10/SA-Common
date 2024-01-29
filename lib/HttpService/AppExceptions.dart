class AppException implements Exception {
  final String? message;
  final String? prefix;
  final String? url;

  AppException([this.message, this.prefix, this.url]);
}

class BadRequestException extends AppException {
  BadRequestException([String? message, String? url])
      : super(message, 'Bad Request', url);
}

class LockException extends AppException {
  LockException([String? message, String? url])
      : super(message, 'Lock Exception', url);
}

class FetchDataException extends AppException {
  FetchDataException([String? message, String? url])
      : super(message, 'Unable to process', url);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([String? message, String? url])
      : super(message, 'Api not responded in time', url);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([String? message, String? url])
      : super(message, 'UnAuthorized request', url);
}

class NotFoundException extends AppException {
  NotFoundException([String? message, String? url])
      : super(message, 'NotFound request', url);
}

class ForbiddenException extends AppException {
  ForbiddenException([String? message, String? url])
      : super(message, 'Forbidden request', url);
}

class ExpectationFailed extends AppException {
  ExpectationFailed([String? message, String? url])
      : super(message, 'ExpectationFailed request', url);
}
