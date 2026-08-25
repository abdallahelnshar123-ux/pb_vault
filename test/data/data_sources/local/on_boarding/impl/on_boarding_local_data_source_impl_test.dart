import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/core/data_bases/cache/local_storage.dart';
import 'package:pb_vault/data/data_sources/local/on_boarding/impl/on_boarding_local_data_source_impl.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late MockLocalStorage mockLocalStorage;
  late OnBoardingLocalDataSourceImpl dataSource;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    dataSource = OnBoardingLocalDataSourceImpl(mockLocalStorage);
  });

  group('checkOnboarding', () {
    test('should return onboarding status from LocalStorage', () {
      // Arrange
      when(() => mockLocalStorage.onboarding).thenReturn(true);

      // Act
      final result = dataSource.checkOnboarding();

      // Assert
      expect(result, isTrue);
      verify(() => mockLocalStorage.onboarding).called(1);
      verifyNoMoreInteractions(mockLocalStorage);
    });

    test(
      'should throw CacheException when LocalStorage throws an exception',
      () {
        // Arrange
        when(
          () => mockLocalStorage.onboarding,
        ).thenThrow(Exception('Storage Error'));

        // Act
        final call = dataSource.checkOnboarding;

        // Assert
        expect(
          call,
          throwsA(
            isA<CacheException>().having(
              (e) => e.message,
              'message',
              'Exception: Storage Error',
            ),
          ),
        );
        verify(() => mockLocalStorage.onboarding).called(1);
        verifyNoMoreInteractions(mockLocalStorage);
      },
    );
  });

  group('setOnboarding', () {
    test('should call setOnboardingDone on LocalStorage', () async {
      // Arrange
      when(
        () => mockLocalStorage.setOnboardingDone(),
      ).thenAnswer((_) async => {});

      // Act
      await dataSource.setOnboarding();

      // Assert
      verify(() => mockLocalStorage.setOnboardingDone()).called(1);
      verifyNoMoreInteractions(mockLocalStorage);
    });

    test(
      'should throw CacheException when LocalStorage throws an exception',
      () async {
        // Arrange
        when(
          () => mockLocalStorage.setOnboardingDone(),
        ).thenThrow(Exception('Storage Error'));

        // Act
        final call = dataSource.setOnboarding;

        // Assert
        expect(
          call,
          throwsA(
            isA<CacheException>().having(
              (e) => e.message,
              'message',
              'Exception: Storage Error',
            ),
          ),
        );
        verify(() => mockLocalStorage.setOnboardingDone()).called(1);
        verifyNoMoreInteractions(mockLocalStorage);
      },
    );
  });
}
