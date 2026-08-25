import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/core/data_bases/cache/local_storage.dart';
import 'package:pb_vault/data/data_sources/local/user/impl/user_local_data_source_impl.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/model/response/my_user_dto.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late MockLocalStorage mockLocalStorage;
  late UserLocalDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(
      const MyUserDto(id: '', email: '', name: '', provider: ''),
    );
  });

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    dataSource = UserLocalDataSourceImpl(mockLocalStorage);
  });

  const tMyUserDto = MyUserDto(
    id: 'user123',
    email: 'test@example.com',
    name: 'Test User',
    provider: 'google',
  );

  group('getUserFromCache', () {
    test('should return MyUserDto when LocalStorage returns data', () {
      // Arrange
      when(() => mockLocalStorage.getUser()).thenReturn(tMyUserDto);

      // Act
      final result = dataSource.getUserFromCache();

      // Assert
      expect(result, tMyUserDto);
      verify(() => mockLocalStorage.getUser()).called(1);
      verifyNoMoreInteractions(mockLocalStorage);
    });

    test('should return null when LocalStorage returns null', () {
      // Arrange
      when(() => mockLocalStorage.getUser()).thenReturn(null);

      // Act
      final result = dataSource.getUserFromCache();

      // Assert
      expect(result, isNull);
      verify(() => mockLocalStorage.getUser()).called(1);
      verifyNoMoreInteractions(mockLocalStorage);
    });

    test(
      'should throw CacheException when LocalStorage throws an exception',
      () {
        // Arrange
        when(
          () => mockLocalStorage.getUser(),
        ).thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(
          () => dataSource.getUserFromCache(),
          throwsA(
            isA<CacheException>().having(
              (e) => e.message,
              'message',
              'Exception: Storage error',
            ),
          ),
        );
        verify(() => mockLocalStorage.getUser()).called(1);
        verifyNoMoreInteractions(mockLocalStorage);
      },
    );
  });

  group('saveUser', () {
    test('should call LocalStorage.saveUser with correct data', () async {
      // Arrange
      when(() => mockLocalStorage.saveUser(any())).thenAnswer((_) async => {});

      // Act
      await dataSource.saveUser(user: tMyUserDto);

      // Assert
      verify(() => mockLocalStorage.saveUser(tMyUserDto)).called(1);
      verifyNoMoreInteractions(mockLocalStorage);
    });

    test(
      'should throw CacheException when LocalStorage.saveUser fails',
      () async {
        // Arrange
        when(
          () => mockLocalStorage.saveUser(any()),
        ).thenThrow(Exception('Save error'));

        // Act & Assert
        await expectLater(
          () => dataSource.saveUser(user: tMyUserDto),
          throwsA(
            isA<CacheException>().having(
              (e) => e.message,
              'message',
              'Exception: Save error',
            ),
          ),
        );
        verify(() => mockLocalStorage.saveUser(tMyUserDto)).called(1);
        verifyNoMoreInteractions(mockLocalStorage);
      },
    );
  });

  group('deleteUser', () {
    test('should call LocalStorage.clearUser', () async {
      // Arrange
      when(() => mockLocalStorage.clearUser()).thenAnswer((_) async => {});

      // Act
      await dataSource.deleteUser();

      // Assert
      verify(() => mockLocalStorage.clearUser()).called(1);
      verifyNoMoreInteractions(mockLocalStorage);
    });

    test(
      'should throw CacheException when LocalStorage.clearUser fails',
      () async {
        // Arrange
        when(
          () => mockLocalStorage.clearUser(),
        ).thenThrow(Exception('Clear error'));

        // Act & Assert
        await expectLater(
          () => dataSource.deleteUser(),
          throwsA(
            isA<CacheException>().having(
              (e) => e.message,
              'message',
              'Exception: Clear error',
            ),
          ),
        );
        verify(() => mockLocalStorage.clearUser()).called(1);
        verifyNoMoreInteractions(mockLocalStorage);
      },
    );
  });
}
