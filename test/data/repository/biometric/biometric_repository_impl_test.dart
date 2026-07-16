import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/core/services/biometric_service/biometric_auth_service.dart';
import 'package:pb_vault/data/data_sources/local/biometric/biometric_local_data_source.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/repository/biometric/biometric_repository_impl.dart';
import 'package:pb_vault/domain/failure/failure.dart';

class MockBiometricAuthService extends Mock implements BiometricAuthService {}

class MockBiometricLocalDataSource extends Mock
    implements BiometricLocalDataSource {}

void main() {
  late MockBiometricLocalDataSource mockLocalDataSource;
  late BiometricRepositoryImpl repository;
  late MockBiometricAuthService mockBiometricAuthService;

  setUp(() {
    mockLocalDataSource = MockBiometricLocalDataSource();
    mockBiometricAuthService = MockBiometricAuthService();
    repository = BiometricRepositoryImpl(
      mockBiometricAuthService,
      mockLocalDataSource,
    );
  });

  group('BiometricRepositoryImpl', () {
    const tSecretKey = [1, 2, 3];
    const tMessage = 'Error message';
    final tException = Exception(tMessage);
    const tCacheException = CacheException(message: tMessage, statusCode: null);

    group('isBiometricSupported', () {
      test('should return Right(true) when device is supported', () async {
        // arrange
        when(
          () => mockBiometricAuthService.canCheckBiometrics(),
        ).thenAnswer((_) async => false);
        when(
          () => mockBiometricAuthService.isDeviceSupported(),
        ).thenAnswer((_) async => true);

        // act
        final result = await repository.isBiometricSupported();

        // assert
        expect(result, equals(const Right(true)));
        verify(() => mockBiometricAuthService.canCheckBiometrics()).called(1);
        verify(() => mockBiometricAuthService.isDeviceSupported()).called(1);
        verifyNoMoreInteractions(mockBiometricAuthService);
      });

      test(
        'should return Right(true) when canCheckBiometrics is true but device is not supported',
        () async {
          // arrange
          when(
            () => mockBiometricAuthService.canCheckBiometrics(),
          ).thenAnswer((_) async => true);
          when(
            () => mockBiometricAuthService.isDeviceSupported(),
          ).thenAnswer((_) async => false);

          // act
          final result = await repository.isBiometricSupported();

          // assert
          expect(result, const Right(true));
          verify(() => mockBiometricAuthService.canCheckBiometrics()).called(1);
          verify(() => mockBiometricAuthService.isDeviceSupported()).called(1);
        },
      );

      test(
        'should return Left(UnexpectedFailure) when an exception occurs',
        () async {
          // arrange
          when(
            () => mockBiometricAuthService.canCheckBiometrics(),
          ).thenThrow(tException);

          // act
          final result = await repository.isBiometricSupported();

          // assert
          expect(result, Left(UnexpectedFailure(tException.toString())));
        },
      );
    });

    group('authenticate', () {
      test(
        'should return Right(true) when authentication is successful',
        () async {
          // arrange
          when(
            () => mockBiometricAuthService.authenticate(),
          ).thenAnswer((_) async => true);

          // act
          final result = await repository.authenticate();

          // assert
          expect(result, const Right(true));
          verify(() => mockBiometricAuthService.authenticate()).called(1);
        },
      );

      test(
        'should return Left(UnexpectedFailure) when an exception occurs',
        () async {
          // arrange
          when(
            () => mockBiometricAuthService.authenticate(),
          ).thenThrow(tException);

          // act
          final result = await repository.authenticate();

          // assert
          expect(result, Left(UnexpectedFailure(tException.toString())));
        },
      );
    });

    group('saveSecretKey', () {
      test('should return Right(unit) when data source succeeds', () async {
        // arrange
        when(
          () => mockLocalDataSource.saveSecretKey(any()),
        ).thenAnswer((_) async => {});

        // act
        final result = await repository.saveSecretKey(tSecretKey);

        // assert
        expect(result, const Right(unit));
        verify(() => mockLocalDataSource.saveSecretKey(tSecretKey)).called(1);
      });

      test(
        'should return Left(CacheFailure) when data source throws CacheException',
        () async {
          // arrange
          when(
            () => mockLocalDataSource.saveSecretKey(any()),
          ).thenThrow(tCacheException);

          // act
          final result = await repository.saveSecretKey(tSecretKey);

          // assert
          expect(result, const Left(CacheFailure(tMessage)));
        },
      );

      test(
        'should return Left(UnexpectedFailure) when data source throws unexpected exception',
        () async {
          // arrange
          when(
            () => mockLocalDataSource.saveSecretKey(any()),
          ).thenThrow(tException);

          // act
          final result = await repository.saveSecretKey(tSecretKey);

          // assert
          expect(result, Left(UnexpectedFailure(tException.toString())));
        },
      );
    });

    group('getSecretKey', () {
      test(
        'should return Right(Some(key)) when data source returns a key',
        () async {
          // arrange
          when(
            () => mockLocalDataSource.getSecretKey(),
          ).thenAnswer((_) async => const Some(tSecretKey));

          // act
          final result = await repository.getSecretKey();

          // assert
          expect(result, const Right(Some(tSecretKey)));
          verify(() => mockLocalDataSource.getSecretKey()).called(1);
        },
      );

      test(
        'should return Left(CacheFailure) when data source throws CacheException',
        () async {
          // arrange
          when(
            () => mockLocalDataSource.getSecretKey(),
          ).thenThrow(tCacheException);

          // act
          final result = await repository.getSecretKey();

          // assert
          expect(result, const Left(CacheFailure(tMessage)));
        },
      );
    });

    group('deleteSecretKey', () {
      test('should return Right(unit) when data source succeeds', () async {
        // arrange
        when(
          () => mockLocalDataSource.deleteSecretKey(),
        ).thenAnswer((_) async => {});

        // act
        final result = await repository.deleteSecretKey();

        // assert
        expect(result, const Right(unit));
        verify(() => mockLocalDataSource.deleteSecretKey()).called(1);
      });

      test(
        'should return Left(CacheFailure) when data source throws CacheException',
        () async {
          // arrange
          when(
            () => mockLocalDataSource.deleteSecretKey(),
          ).thenThrow(tCacheException);

          // act
          final result = await repository.deleteSecretKey();

          // assert
          expect(result, const Left(CacheFailure(tMessage)));
        },
      );
    });

    group('setBiometricEnabled', () {
      test('should return Right(unit) when data source succeeds', () async {
        // arrange
        when(
          () => mockLocalDataSource.setBiometricEnabled(any()),
        ).thenAnswer((_) async => {});

        // act
        final result = await repository.setBiometricEnabled(true);

        // assert
        expect(result, const Right(unit));
        verify(() => mockLocalDataSource.setBiometricEnabled(true)).called(1);
      });

      test(
        'should return Left(CacheFailure) when data source throws CacheException',
        () async {
          // arrange
          when(
            () => mockLocalDataSource.setBiometricEnabled(any()),
          ).thenThrow(tCacheException);

          // act
          final result = await repository.setBiometricEnabled(true);

          // assert
          expect(result, const Left(CacheFailure(tMessage)));
        },
      );
    });

    group('isBiometricEnabled', () {
      test('should return Right(bool) when data source succeeds', () {
        // arrange
        when(() => mockLocalDataSource.isBiometricEnabled()).thenReturn(true);

        // act
        final result = repository.isBiometricEnabled();

        // assert
        expect(result, const Right(true));
        verify(() => mockLocalDataSource.isBiometricEnabled()).called(1);
      });

      test(
        'should return Left(CacheFailure) when data source throws CacheException',
        () {
          // arrange
          when(
            () => mockLocalDataSource.isBiometricEnabled(),
          ).thenThrow(tCacheException);

          // act
          final result = repository.isBiometricEnabled();

          // assert
          expect(result, const Left(CacheFailure(tMessage)));
        },
      );
    });

    group('setBiometricRejected', () {
      test('should return Right(unit) when data source succeeds', () async {
        // arrange
        when(
          () => mockLocalDataSource.setBiometricRejected(any()),
        ).thenAnswer((_) async => {});

        // act
        final result = await repository.setBiometricRejected(true);

        // assert
        expect(result, const Right(unit));
        verify(() => mockLocalDataSource.setBiometricRejected(true)).called(1);
      });

      test(
        'should return Left(CacheFailure) when data source throws CacheException',
        () async {
          // arrange
          when(
            () => mockLocalDataSource.setBiometricRejected(any()),
          ).thenThrow(tCacheException);

          // act
          final result = await repository.setBiometricRejected(true);

          // assert
          expect(result, const Left(CacheFailure(tMessage)));
        },
      );
    });

    group('isBiometricRejected', () {
      test('should return Right(bool) when data source succeeds', () {
        // arrange
        when(() => mockLocalDataSource.isBiometricRejected()).thenReturn(true);

        // act
        final result = repository.isBiometricRejected();

        // assert
        expect(result, const Right(true));
        verify(() => mockLocalDataSource.isBiometricRejected()).called(1);
      });

      test(
        'should return Left(CacheFailure) when data source throws CacheException',
        () {
          // arrange
          when(
            () => mockLocalDataSource.isBiometricRejected(),
          ).thenThrow(tCacheException);

          // act
          final result = repository.isBiometricRejected();

          // assert
          expect(result, const Left(CacheFailure(tMessage)));
        },
      );
    });
  });
}
