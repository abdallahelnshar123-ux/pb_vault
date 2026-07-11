import 'package:flutter_test/flutter_test.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/mapper/exception_mapper.dart';
import 'package:pb_vault/domain/failure/failure.dart';

void main() {
  group('ExceptionMapper', () {
    test('should map NetworkException to NetworkFailure', () {
      const message = 'Network Error';
      const exception = NetworkException(message: message, statusCode: 500);
      expect(exception.toFailure(), const NetworkFailure(message));
    });

    test('should map UnauthorizedException to UnauthorizedFailure', () {
      const message = 'Unauthorized';
      const exception = UnauthorizedException(message: message, statusCode: 401);
      expect(exception.toFailure(), const UnauthorizedFailure(message));
    });

    test('should map ServerException to ServerFailure', () {
      const message = 'Server Error';
      const exception = ServerException(message: message, statusCode: 500);
      expect(exception.toFailure(), const ServerFailure(message));
    });

    test('should map CancelledByUserException to CancelledByUserFailure', () {
      const exception = CancelledByUserException();
      expect(exception.toFailure(), const CancelledByUserFailure());
    });

    test('should map CacheException to CacheFailure', () {
      const message = 'Cache Error';
      const exception = CacheException(message: message, statusCode: null);
      expect(exception.toFailure(), const CacheFailure(message));
    });

    test('should map UnexpectedException (or any other) to UnexpectedFailure', () {
      const message = 'Unexpected Error';
      const exception = UnexpectedException(message: message, statusCode: null);
      expect(exception.toFailure(), const UnexpectedFailure(message));
    });
  });
}
