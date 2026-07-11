import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/data/data_sources/local/user/user_local_data_source.dart';
import 'package:pb_vault/data/data_sources/remote/user/user_remote_data_source.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/mapper/my_user_dto_mapper.dart';
import 'package:pb_vault/data/mapper/my_user_mapper.dart';
import 'package:pb_vault/data/model/response/my_user_dto.dart';
import 'package:pb_vault/data/repository/user/user_repository_impl.dart';
import 'package:pb_vault/domain/entities/response/user/auth_providers.dart';
import 'package:pb_vault/domain/failure/failure.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

void main() {
  late MockUserRemoteDataSource mockRemoteDataSource;
  late MockUserLocalDataSource mockLocalDataSource;
  late UserRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      const MyUserDto(id: '', email: '', name: '', provider: ''),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockLocalDataSource = MockUserLocalDataSource();
    repository = UserRepositoryImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  const tUid = '123';
  const tMyUserDto = MyUserDto(
    id: tUid,
    email: 'test@example.com',
    name: 'Test User',
    provider: AuthProviders.google,
  );
  final tMyUser = tMyUserDto.toUser();

  group('getUserFromRemoteDataSource', () {
    test('should return Right(Some(MyUser)) when user is found', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getUser(any()),
      ).thenAnswer((_) async => tMyUserDto);

      // Act
      final result = await repository.getUserFromRemoteDataBase(uId: tUid);

      // Assert
      expect(result, Right(Some(tMyUser)));
      verify(() => mockRemoteDataSource.getUser(tUid)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should return Right(None()) when user is not found', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getUser(any()),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.getUserFromRemoteDataBase(uId: tUid);

      // Assert
      expect(result, const Right(None()));
      verify(() => mockRemoteDataSource.getUser(tUid)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
    });

    test(
      'should return Left(ServerFailure) when remote data source throws ServerException',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getUser(any()),
        ).thenThrow(const ServerException(message: 'Server Error'));

        // Act
        final result = await repository.getUserFromRemoteDataBase(uId: tUid);

        // Assert
        expect(result, const Left(ServerFailure('Server Error')));
        verify(()=> mockRemoteDataSource.getUser(tUid )).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource);
      },
    );

    test(
      'should return Left(UnexpectedFailure) when remote data source throws UnexpectedException',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getUser(any()),
        ).thenThrow(const UnexpectedException(message: 'unexpected error'));

        // Act
        final result = await repository.getUserFromRemoteDataBase(uId: tUid);

        // Assert
        expect(result, const Left(UnexpectedFailure('unexpected error')));
        verify(()=> mockRemoteDataSource.getUser(tUid )).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource);
      },
    );
  });

  group('createDatabaseUser', () {
    test(
      'should call remoteDataSource.createUser and return Right(unit)',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.createUser(any()),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.createDatabaseUser(user: tMyUser);

        // Assert
        expect(result, const Right(unit));
        verify(
          () => mockRemoteDataSource.createUser(tMyUser.toMyUserDto()),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource);
      },
    );
  });

  group('deleteDatabaseUser', () {
    test(
      'should call both data sources to delete user and return Right(unit)',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.deleteUser(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockLocalDataSource.deleteUser(),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.deleteDatabaseUser(uId: tUid);

        // Assert
        expect(result, const Right(unit));
        verify(() => mockRemoteDataSource.deleteUser(tUid)).called(1);
        verify(() => mockLocalDataSource.deleteUser()).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('updateDatabaseUser', () {
    test('should call both data sources to update and save user', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.updateUser(any()),
      ).thenAnswer((_) async => {});
      when(
        () => mockLocalDataSource.saveUser(user: any(named: 'user')),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.updateDatabaseUser(user: tMyUser);

      // Assert
      expect(result, const Right(unit));
      verify(
        () => mockRemoteDataSource.updateUser(tMyUser.toMyUserDto()),
      ).called(1);
      verify(
        () => mockLocalDataSource.saveUser(user: tMyUser.toMyUserDto()),
      ).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('getUserFromCache', () {
    test('should return Right(Some(MyUser)) when user is in cache', () {
      // Arrange
      when(() => mockLocalDataSource.getUserFromCache()).thenReturn(tMyUserDto);

      // Act
      final result = repository.getUserFromCache();

      // Assert
      expect(result, Right(Some(tMyUser)));
      verify(() => mockLocalDataSource.getUserFromCache()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should return Right(None()) when cache is empty', () {
      // Arrange
      when(() => mockLocalDataSource.getUserFromCache()).thenReturn(null);

      // Act
      final result = repository.getUserFromCache();

      // Assert
      expect(result, const Right(None()));
      verify(() => mockLocalDataSource.getUserFromCache()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
    });
  });

  group('setMasterPassword', () {
    test(
      'should update remote and save local and return Right(unit)',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.updateUser(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockLocalDataSource.saveUser(user: any(named: 'user')),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.setMasterPassword(user: tMyUser);

        // Assert
        expect(result, const Right(unit));
        verify(
          () => mockRemoteDataSource.updateUser(tMyUser.toMyUserDto()),
        ).called(1);
        verify(
          () => mockLocalDataSource.saveUser(user: tMyUser.toMyUserDto()),
        ).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });
}
