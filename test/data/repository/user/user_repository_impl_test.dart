import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/data/data_sources/local/user/user_local_data_source.dart';
import 'package:pb_vault/data/data_sources/remote/user/user_remote_data_source.dart';
import 'package:pb_vault/data/data_sources/remote/vault/vault_remote_data_source.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/mapper/my_user_mapper.dart';
import 'package:pb_vault/data/model/response/my_user_dto.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/encrypted_data_dto.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_account_dto.dart';
import 'package:pb_vault/data/repository/user/user_repository_impl.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/user/user_repository.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

class MockVaultRemoteDataSource extends Mock implements VaultRemoteDataSource {}

void main() {
  late UserRepository repository;
  late MockUserRemoteDataSource mockRemoteDataSource;
  late MockUserLocalDataSource mockLocalDataSource;
  late MockVaultRemoteDataSource mockVaultRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockLocalDataSource = MockUserLocalDataSource();
    mockVaultRemoteDataSource = MockVaultRemoteDataSource();
    repository = UserRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockVaultRemoteDataSource,
    );
  });

  const tUid = '123';
  const tUserDto = MyUserDto(
    id: tUid,
    email: 'test@example.com',
    name: 'Test User',
    provider: 'google',
  );
  final tUser = tUserDto.toUser();

  group('getUserFromRemoteDataBase', () {
    test('should return Right(Some(MyUser)) when remote call is successful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.getUser(any()))
          .thenAnswer((_) async => tUserDto);

      // Act
      final result = await repository.getUserFromRemoteDataBase(uId: tUid);

      // Assert
      expect(result, Right(Some(tUser)));
      verify(() => mockRemoteDataSource.getUser(tUid)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockVaultRemoteDataSource);
    });

    test('should return Right(None()) when remote call returns null', () async {
      // Arrange
      when(() => mockRemoteDataSource.getUser(any()))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getUserFromRemoteDataBase(uId: tUid);

      // Assert
      expect(result, const Right(None()));
      verify(() => mockRemoteDataSource.getUser(tUid)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote call throws ServerException',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.getUser(any())).thenThrow(
          const ServerException(message: 'error', statusCode: 500));

      // Act
      final result = await repository.getUserFromRemoteDataBase(uId: tUid);

      // Assert
      expect(result, const Left(ServerFailure('error')));
      verify(() => mockRemoteDataSource.getUser(tUid)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
        'should return Left(UnexpectedFailure) when remote call throws generic Exception',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.getUser(any())).thenThrow(Exception('error'));

      // Act
      final result = await repository.getUserFromRemoteDataBase(uId: tUid);

      // Assert
      expect(result, const Left(UnexpectedFailure('Exception: error')));
      verify(() => mockRemoteDataSource.getUser(tUid)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('createDatabaseUser', () {
    setUpAll(() {
      registerFallbackValue(tUserDto);
    });

    test('should return Right(unit) when remote call is successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.createUser(any()))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.createDatabaseUser(user: tUser);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockRemoteDataSource.createUser(tUserDto)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should return Left(Failure) when remote call throws AppException',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.createUser(any())).thenThrow(
          const ServerException(message: 'error', statusCode: 500));

      // Act
      final result = await repository.createDatabaseUser(user: tUser);

      // Assert
      expect(result, const Left(ServerFailure('error')));
      verify(() => mockRemoteDataSource.createUser(tUserDto)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('deleteDatabaseUser', () {
    test('should return Right(unit) when calls are successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.deleteUser(any()))
          .thenAnswer((_) async => {});
      when(() => mockLocalDataSource.deleteUser()).thenAnswer((_) async => {});

      // Act
      final result = await repository.deleteDatabaseUser(uId: tUid);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockRemoteDataSource.deleteUser(tUid)).called(1);
      verify(() => mockLocalDataSource.deleteUser()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return Left(Failure) when remote call fails and should NOT call local', () async {
      // Arrange
      when(() => mockRemoteDataSource.deleteUser(any())).thenThrow(const ServerException(message: 'error', statusCode: 500));

      // Act
      final result = await repository.deleteDatabaseUser(uId: tUid);

      // Assert
      expect(result, const Left(ServerFailure('error')));
      verify(() => mockRemoteDataSource.deleteUser(tUid)).called(1);
      verifyZeroInteractions(mockLocalDataSource);
    });
  });

  group('updateDatabaseUser', () {
    setUpAll(() {
      registerFallbackValue(tUserDto);
    });

    test('should return Right(unit) when calls are successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.updateUser(any()))
          .thenAnswer((_) async => {});
      when(() => mockLocalDataSource.saveUser(user: any(named: 'user')))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.updateDatabaseUser(user: tUser);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockRemoteDataSource.updateUser(tUserDto)).called(1);
      verify(() => mockLocalDataSource.saveUser(user: tUserDto)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('getUserFromCache', () {
    test('should return Right(Some(MyUser)) when local call is successful', () {
      // Arrange
      when(() => mockLocalDataSource.getUserFromCache()).thenReturn(tUserDto);

      // Act
      final result = repository.getUserFromCache();

      // Assert
      expect(result, Right(Some(tUser)));
      verify(() => mockLocalDataSource.getUserFromCache()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return Right(None()) when local call returns null', () {
      // Arrange
      when(() => mockLocalDataSource.getUserFromCache()).thenReturn(null);

      // Act
      final result = repository.getUserFromCache();

      // Assert
      expect(result, const Right(None()));
      verify(() => mockLocalDataSource.getUserFromCache()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('setMasterPassword', () {
    setUpAll(() {
      registerFallbackValue(tUserDto);
    });
    test('should return Right(unit) when calls are successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.updateUser(any()))
          .thenAnswer((_) async => {});
      when(() => mockLocalDataSource.saveUser(user: any(named: 'user')))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.setMasterPassword(user: tUser);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockRemoteDataSource.updateUser(tUserDto)).called(1);
      verify(() => mockLocalDataSource.saveUser(user: tUserDto)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('changeMasterPassword', () {
    final tCreatedAt = DateTime(2023, 1, 1);
    final tAccounts = [
      PlatformAccount(
        id: 'acc1',
        platformId: 'plat1',
        identifier: 'user1',
        password: 'pass1',
        notes: 'note1',
        recoveryCodes: 'rec1',
        passkey: 'key1',
        twoFactorSecret: 'secret1',
        createdAt: tCreatedAt,
      ),
    ];

    const tEncryptedData = EncryptedDataDto(
      cipherText: [1],
      nonce: [2],
      mac: [3],
    );

    setUpAll(() {
      registerFallbackValue(tUserDto);
      registerFallbackValue(<PlatformAccountDto>[]);
    });

    test(
        'should return Right(unit) when accounts is empty and calls are successful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.changeMasterPassword(
            uId: any(named: 'uId'),
            userDto: any(named: 'userDto'),
            accounts: any(named: 'accounts'),
          )).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.saveUser(user: any(named: 'user')))
          .thenAnswer((_) async => {});

      // Act
      final result =
          await repository.changeMasterPassword(user: tUser, accounts: []);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockRemoteDataSource.changeMasterPassword(
            uId: tUid,
            userDto: tUserDto,
            accounts: [],
          )).called(1);
      verify(() => mockLocalDataSource.saveUser(user: tUserDto)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockVaultRemoteDataSource);
    });

    test(
        'should return Right(unit) when accounts is not empty, encryption and calls are successful',
        () async {
      // Arrange
      final tEncryptedList = List.generate(5, (_) => tEncryptedData);
      when(() => mockVaultRemoteDataSource.encryptMultiple(any()))
          .thenAnswer((_) async => tEncryptedList);
      when(() => mockRemoteDataSource.changeMasterPassword(
            uId: any(named: 'uId'),
            userDto: any(named: 'userDto'),
            accounts: any(named: 'accounts'),
          )).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.saveUser(user: any(named: 'user')))
          .thenAnswer((_) async => {});

      // Act
      final result =
          await repository.changeMasterPassword(user: tUser, accounts: tAccounts);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockVaultRemoteDataSource.encryptMultiple([
            'pass1',
            'note1',
            'rec1',
            'key1',
            'secret1',
          ])).called(1);
      
      final expectedAccountDtos = [
        PlatformAccountDto(
          id: 'acc1',
          platformId: 'plat1',
          identifier: 'user1',
          createdAt: tCreatedAt,
          password: tEncryptedData,
          notes: tEncryptedData,
          recoveryCodes: tEncryptedData,
          passkey: tEncryptedData,
          twoFactorSecret: tEncryptedData,
          customFields: const [],
          loginMethods: const [],
        )
      ];

      verify(() => mockRemoteDataSource.changeMasterPassword(
            uId: tUid,
            userDto: tUserDto,
            accounts: expectedAccountDtos,
          )).called(1);
      verify(() => mockLocalDataSource.saveUser(user: tUserDto)).called(1);
      
      verifyNoMoreInteractions(mockVaultRemoteDataSource);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test(
        'should return Right(unit) when multiple accounts are provided',
        () async {
      // Arrange
      final tAccounts2 = [
        ...tAccounts,
        PlatformAccount(
          id: 'acc2',
          platformId: 'plat2',
          identifier: 'user2',
          password: 'pass2',
          createdAt: tCreatedAt,
        ),
      ];
      final tEncryptedList = List.generate(10, (_) => tEncryptedData);
      when(() => mockVaultRemoteDataSource.encryptMultiple(any()))
          .thenAnswer((_) async => tEncryptedList);
      when(() => mockRemoteDataSource.changeMasterPassword(
            uId: any(named: 'uId'),
            userDto: any(named: 'userDto'),
            accounts: any(named: 'accounts'),
          )).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.saveUser(user: any(named: 'user')))
          .thenAnswer((_) async => {});

      // Act
      final result =
          await repository.changeMasterPassword(user: tUser, accounts: tAccounts2);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockVaultRemoteDataSource.encryptMultiple([
            'pass1', 'note1', 'rec1', 'key1', 'secret1',
            'pass2', null, null, null, null,
          ])).called(1);

      verify(() => mockRemoteDataSource.changeMasterPassword(
            uId: tUid,
            userDto: tUserDto,
            accounts: any(named: 'accounts', that: hasLength(2)),
          )).called(1);
      verify(() => mockLocalDataSource.saveUser(user: tUserDto)).called(1);

      verifyNoMoreInteractions(mockVaultRemoteDataSource);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return Left(Failure) when encryption fails', () async {
      // Arrange
      when(() => mockVaultRemoteDataSource.encryptMultiple(any()))
          .thenThrow(const ServerException(message: 'encrypt error', statusCode: 500));

      // Act
      final result =
          await repository.changeMasterPassword(user: tUser, accounts: tAccounts);

      // Assert
      expect(result, const Left(ServerFailure('encrypt error')));
      verify(() => mockVaultRemoteDataSource.encryptMultiple(any())).called(1);
      verifyNoMoreInteractions(mockVaultRemoteDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
    });
  });
}
