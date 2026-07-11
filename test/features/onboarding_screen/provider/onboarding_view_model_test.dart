import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/use_cases/set_onboarding_done_use_case.dart';
import 'package:pb_vault/features/onboarding_screen/provider/onboarding_view_model.dart';

class MockSetOnboardingDoneUseCase extends Mock implements SetOnboardingDoneUseCase {}

void main() {
  late OnboardingViewModel viewModel;
  late MockSetOnboardingDoneUseCase mockSetOnboardingDoneUseCase;

  setUp(() {
    mockSetOnboardingDoneUseCase = MockSetOnboardingDoneUseCase();
    viewModel = OnboardingViewModel(mockSetOnboardingDoneUseCase);
  });

  group('OnboardingViewModel', () {
    test('initial currentIndex should be 0', () {
      expect(viewModel.currentIndex, 0);
    });

    group('changeIndex', () {
      test('should update currentIndex and notify listeners when index is different', () {
        bool notified = false;
        viewModel.addListener(() => notified = true);

        viewModel.changeIndex(1);

        expect(viewModel.currentIndex, 1);
        expect(notified, isTrue);
      });

      test('should not notify listeners when index is the same', () {
        bool notified = false;
        viewModel.addListener(() => notified = true);

        viewModel.changeIndex(0);

        expect(viewModel.currentIndex, 0);
        expect(notified, isFalse);
      });
    });

    group('onFirstButtonClick', () {
      test('should increment currentIndex when not on the last page', () {
        bool notified = false;
        viewModel.addListener(() => notified = true);
        viewModel.currentIndex = 0;
        viewModel.onFirstButtonClick();

        expect(viewModel.currentIndex, 1);
        expect(notified, isTrue);
        verifyZeroInteractions(mockSetOnboardingDoneUseCase);
      });

      test('should call setOnboardingDone on last page', () {
        // Set to last page (index 2 for 3 pages)
        bool notified = false;
        viewModel.addListener(() => notified = true);
        viewModel.currentIndex = viewModel.onboardingPagesNumber - 1;
        
        viewModel.onFirstButtonClick();

        verify(() => mockSetOnboardingDoneUseCase.setOnboardingDone()).called(1);
        expect(notified, isFalse);
        verifyNoMoreInteractions(mockSetOnboardingDoneUseCase);
      });
    });

    group('onSecondButtonClick', () {
      test('should call setOnboardingDone', () {
        viewModel.onSecondButtonClick();

        verify(() => mockSetOnboardingDoneUseCase.setOnboardingDone()).called(1);
        verifyNoMoreInteractions(mockSetOnboardingDoneUseCase);
      });
    });
  });
}
