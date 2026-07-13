import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/core/data_bases/cache/local_storage.dart';
import 'package:pb_vault/core/data_bases/secure_storage/secure_storage_keys.dart';
import 'package:pb_vault/core/data_bases/secure_storage/secure_storage_utils.dart';
import 'package:pb_vault/data/data_sources/local/biometric/impl/biometric_local_data_source_impl.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

class MockSecureStorageUtils extends Mock implements SecureStorageUtils {}

void main() {
  late MockLocalStorage mockLocalStorage;
  late MockSecureStorageUtils mockSecureStorage;
  late BiometricLocalDataSourceImpl dataSource;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    mockSecureStorage = MockSecureStorageUtils();
    dataSource = BiometricLocalDataSourceImpl(mockLocalStorage, mockSecureStorage);
  });

  group('BiometricLocalDataSourceImpl', () {
    const tSecretKey = [1, 2, 3, 4];
    final tException = Exception('Test error');

    group('saveSecretKey', () {
      test('should call secureStorage.writeBytes with correct parameters', () async {
        // arrange
        when(() => mockSecureStorage.writeBytes(any(), any()))
            .thenAnswer((_) async => {});

        // act
        await dataSource.saveSecretKey(tSecretKey);

        // assert
        verify(() => mockSecureStorage.writeBytes(SecureStorageKeys.secretKey, tSecretKey))
            .called(1);
        verifyNoMoreInteractions(mockSecureStorage);
        verifyZeroInteractions(mockLocalStorage);
      });

      test('should throw CacheException when secureStorage throws an exception', () async {
        // arrange
        when(() => mockSecureStorage.writeBytes(any(), any()))
            .thenThrow(tException);

        // act
        final call = dataSource.saveSecretKey;

        // assert
        expect(
          () => call(tSecretKey),
          throwsA(
            isA<CacheException>().having(
              (e) => e.message,
              'message',
              contains(tException.toString()),
            ),
          ),
        );
        verify(() => mockSecureStorage.writeBytes(SecureStorageKeys.secretKey, tSecretKey))
            .called(1);
      });
    });

    group('getSecretKey', () {
      test('should return Some(List<int>) when key exists in secure storage', () async {
        // arrange
        when(() => mockSecureStorage.readBytes(any()))
            .thenAnswer((_) async => tSecretKey);

        // act
        final result = await dataSource.getSecretKey();

        // assert
        expect(result, equals(const Some(tSecretKey)));
        verify(() => mockSecureStorage.readBytes(SecureStorageKeys.secretKey)).called(1);
        verifyNoMoreInteractions(mockSecureStorage);
        verifyZeroInteractions(mockLocalStorage);
      });

      test('should return None when key does not exist in secure storage', () async {
        // arrange
        when(() => mockSecureStorage.readBytes(any()))
            .thenAnswer((_) async => null);

        // act
        final result = await dataSource.getSecretKey();

        // assert
        expect(result, equals(const None()));
        verify(() => mockSecureStorage.readBytes(SecureStorageKeys.secretKey)).called(1);
      });

      test('should throw CacheException when secureStorage throws an exception', () async {
        // arrange
        when(() => mockSecureStorage.readBytes(any())).thenThrow(tException);

        // act
        final call = dataSource.getSecretKey;

        // assert
        expect(
          () => call(),
          throwsA(
            isA<CacheException>().having(
              (e) => e.message,
              'message',
              contains(tException.toString()),
            ),
          ),
        );
        verify(() => mockSecureStorage.readBytes(SecureStorageKeys.secretKey)).called(1);
      });
    });

    group('deleteSecretKey', () {
      test('should call secureStorage.delete with correct key', () async {
        // arrange
        when(() => mockSecureStorage.delete(any()))
            .thenAnswer((_) async => {});

        // act
        await dataSource.deleteSecretKey();

        // assert
        verify(() => mockSecureStorage.delete(SecureStorageKeys.secretKey)).called(1);
        verifyNoMoreInteractions(mockSecureStorage);
        verifyZeroInteractions(mockLocalStorage);
      });

      test('should throw CacheException when secureStorage throws an exception', () async {
        // arrange
        when(() => mockSecureStorage.delete(any())).thenThrow(tException);

        // act
        final call = dataSource.deleteSecretKey;

        // assert
        expect(
          () => call(),
          throwsA(
            isA<CacheException>().having(
              (e) => e.message,
              'message',
              contains(tException.toString()),
            ),
          ),
        );
        verify(() => mockSecureStorage.delete(SecureStorageKeys.secretKey)).called(1);
      });
    });

    group('setBiometricEnabled', () {
      test('should call localStorage.setUseBiometric with correct value', () async {
        // arrange
        when(() => mockLocalStorage.setUseBiometric(any()))
            .thenAnswer((_) async => {});

        // act
        await dataSource.setBiometricEnabled(true);

        // assert
        verify(() => mockLocalStorage.setUseBiometric(true)).called(1);
        verifyNoMoreInteractions(mockLocalStorage);
        verifyZeroInteractions(mockSecureStorage);
      });

      test('should throw CacheException when localStorage throws an exception', () async {
        // arrange
        when(() => mockLocalStorage.setUseBiometric(any())).thenThrow(tException);

        // act
        final call = dataSource.setBiometricEnabled;

        // assert
        expect(
          () => call(true),
          throwsA(
            isA<CacheException>().having(
              (e) => e.message,
              'message',
              contains(tException.toString()),
            ),
          ),
        );
        verify(() => mockLocalStorage.setUseBiometric(true)).called(1);
      });
    });

    group('isBiometricEnabled', () {
      test('should return value from localStorage.useBiometric', () {
        // arrange
        when(() => mockLocalStorage.useBiometric).thenReturn(true);

        // act
        final result = dataSource.isBiometricEnabled();

        // assert
        expect(result, isTrue);
        verify(() => mockLocalStorage.useBiometric).called(1);
        verifyNoMoreInteractions(mockLocalStorage);
        verifyZeroInteractions(mockSecureStorage);
      });

      test('should throw CacheException when localStorage throws an exception', () {
        // arrange
        when(() => mockLocalStorage.useBiometric).thenThrow(tException);

        // act
        final call = dataSource.isBiometricEnabled;

        // assert
        expect(
          () => call(),
          throwsA(
            isA<CacheException>().having(
              (e) => e.message,
              'message',
              contains(tException.toString()),
            ),
          ),
        );
        verify(() => mockLocalStorage.useBiometric).called(1);
      });
    });
  });
}
