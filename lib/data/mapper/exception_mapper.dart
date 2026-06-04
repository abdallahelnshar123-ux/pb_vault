import '../../domain/failure/failure.dart';
import '../exceptions/app_exceptions.dart';

extension ExceptionMapper on AppException {
  Failure toFailure() {
    switch (this) {
      case NetworkException():
        return NetworkFailure(message);

      case UnauthorizedException():
        return UnauthorizedFailure(message);

      case ServerException():
        return ServerFailure(message);

      case CacheException():
        return CacheFailure(message);

      default:
        return UnexpectedFailure(message);
    }
  }
}
