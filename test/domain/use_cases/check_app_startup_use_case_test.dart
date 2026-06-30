import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/user/my_user.dart';
import 'package:pb_vault/domain/entities/startup_result/startup_result.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/on_boarding/on_boarding_repository.dart';
import 'package:pb_vault/domain/repository/user/user_repository.dart';
import 'package:pb_vault/domain/use_cases/check_app_startup_use_case.dart';

class MockUserRepository extends Mock implements UserRepository {}
class MockOnBoardingRepository extends Mock implements OnBoardingRepository {}

void main() {
  late CheckAppStartupUseCase startupUseCase;
  late MockUserRepository mockUserRepository;
  late MockOnBoardingRepository mockOnBoardingRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockOnBoardingRepository = MockOnBoardingRepository();
    startupUseCase = CheckAppStartupUseCase(
      mockOnBoardingRepository,
      mockUserRepository,
    );
  });

  const tMyUser = MyUser(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
    provider: 'google',
  );

  group('CheckAppStartupUseCase', () {
    test(
      'should return StartupStatus.onboarding when checkOnboarding returns true',
      () {
        // Arrange
        when(() => mockOnBoardingRepository.checkOnboarding())
            .thenReturn(const Right(true));

        // Act
        final result = startupUseCase.checkAppStartup();

        // Assert
        expect(result.status, StartupStatus.onboarding);
        verify(() => mockOnBoardingRepository.checkOnboarding()).called(1);
        verifyZeroInteractions(mockUserRepository);
      },
    );

    test(
      'should return StartupStatus.onboarding when checkOnboarding returns a Failure',
      () {
        // Arrange
        when(() => mockOnBoardingRepository.checkOnboarding())
            .thenReturn(const Left(CacheFailure('Error')));

        // Act
        final result = startupUseCase.checkAppStartup();

        // Assert
        expect(result.status, StartupStatus.onboarding);
        verify(() => mockOnBoardingRepository.checkOnboarding()).called(1);
        verifyZeroInteractions(mockUserRepository);
      },
    );

    test(
      'should return StartupStatus.authenticated when onBoarding is false and user is in cache',
      () {
        // Arrange
        when(() => mockOnBoardingRepository.checkOnboarding())
            .thenReturn(const Right(false));
        when(() => mockUserRepository.getUserFromCache())
            .thenReturn(const Right(Some(tMyUser)));

        // Act
        final result = startupUseCase.checkAppStartup();

        // Assert
        expect(result.status, StartupStatus.authenticated);
        expect(result.user, tMyUser);
        verify(() => mockOnBoardingRepository.checkOnboarding()).called(1);
        verify(() => mockUserRepository.getUserFromCache()).called(1);
      },
    );

    test(
      'should return StartupStatus.unauthenticated when onBoarding is false and no user in cache',
      () {
        // Arrange
        when(() => mockOnBoardingRepository.checkOnboarding())
            .thenReturn(const Right(false));
        when(() => mockUserRepository.getUserFromCache())
            .thenReturn(const Right(None()));

        // Act
        final result = startupUseCase.checkAppStartup();

        // Assert
        expect(result.status, StartupStatus.unauthenticated);
        expect(result.user, null);
        verify(() => mockOnBoardingRepository.checkOnboarding()).called(1);
        verify(() => mockUserRepository.getUserFromCache()).called(1);
      },
    );

    test(
      'should return StartupStatus.unauthenticated when onBoarding is false and getUserFromCache fails',
      () {
        // Arrange
        when(() => mockOnBoardingRepository.checkOnboarding())
            .thenReturn(const Right(false));
        when(() => mockUserRepository.getUserFromCache())
            .thenReturn(const Left(CacheFailure('Error')));

        // Act
        final result = startupUseCase.checkAppStartup();

        // Assert
        expect(result.status, StartupStatus.unauthenticated);
        expect(result.user, null);
        verify(() => mockOnBoardingRepository.checkOnboarding()).called(1);
        verify(() => mockUserRepository.getUserFromCache()).called(1);
      },
    );
  });
}
