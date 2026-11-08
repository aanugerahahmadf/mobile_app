import '../AppErrorCodes/AppErrorCodes.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = AppErrorCodes.networkError]);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = AppErrorCodes.serverError]);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = AppErrorCodes.sessionExpired]);
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;
  const ValidationFailure(this.errors, [super.message = AppErrorCodes.validationFailed]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = AppErrorCodes.dataNotFound]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = AppErrorCodes.anErrorOccurred]);
}
