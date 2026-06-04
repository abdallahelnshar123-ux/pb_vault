import 'package:injectable/injectable.dart';

import '../repository/on_boarding/on_boarding_repository.dart';

@injectable
class SetOnboardingDoneUseCase {
  final OnBoardingRepository _onBoardingRepository;

  SetOnboardingDoneUseCase(this._onBoardingRepository);

  void setOnboardingDone() {
    _onBoardingRepository.setOnboarding();
  }
}
