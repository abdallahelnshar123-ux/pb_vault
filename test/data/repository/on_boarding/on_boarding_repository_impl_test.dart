import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/data/data_sources/local/on_boarding/on_boarding_local_data_source.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/repository/on_boarding/on_boarding_repository_impl.dart';
import 'package:pb_vault/domain/failure/failure.dart';

class MockOnBoardingLocalDataSource extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late MockOnBoardingLocalDataSource mockLocalDataSource;
  late OnBoardingRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockOnBoardingLocalDataSource();
    repository = OnBoardingRepositoryImpl(mockLocalDataSource);
  });

  group('checkOnboarding', () {
    test('should return Right(true) when local data source returns true', () {
      // Arrange
      when(() => mockLocalDataSource.checkOnboarding()).thenReturn(true);

      // Act
      final result = repository.checkOnboarding();

      // Assert
      expect(result, const Right(true));
      verify(() => mockLocalDataSource.checkOnboarding()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return Left(CacheFailure) when local data source throws AppException', () {
      // Arrange
      const tException = CacheException(message: 'Cache Error', statusCode: 500);
      when(() => mockLocalDataSource.checkOnboarding()).thenThrow(tException);

      // Act
      final result = repository.checkOnboarding();

      // Assert
      expect(result, const Left(CacheFailure('Cache Error')));
      verify(() => mockLocalDataSource.checkOnboarding()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('setOnboarding', () {
    test('should call setOnboarding on local data source', () {
      // Arrange
      when(() => mockLocalDataSource.setOnboarding()).thenAnswer((_) => {});

      // Act
      repository.setOnboarding();

      // Assert
      verify(() => mockLocalDataSource.setOnboarding()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });
}
