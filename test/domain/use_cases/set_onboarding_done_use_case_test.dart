import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/repository/on_boarding/on_boarding_repository.dart';
import 'package:pb_vault/domain/use_cases/set_onboarding_done_use_case.dart';

class MockOnBoardingRepository extends Mock implements OnBoardingRepository {}

void main() {
  late MockOnBoardingRepository mockOnBoardingRepo;
  late SetOnboardingDoneUseCase useCase;

  setUp(() {
    mockOnBoardingRepo = MockOnBoardingRepository();
    useCase = SetOnboardingDoneUseCase(mockOnBoardingRepo);
  });

  test('should call OnBoardingRepository.setOnboarding', () {
    // Act
    useCase.setOnboardingDone();

    // Assert
    verify(() => mockOnBoardingRepo.setOnboarding()).called(1);
    verifyNoMoreInteractions(mockOnBoardingRepo);
  });
}
