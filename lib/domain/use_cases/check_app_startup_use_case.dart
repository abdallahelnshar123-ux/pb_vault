import 'package:injectable/injectable.dart';

import '../entities/startup_result/startup_result.dart';
import '../repository/on_boarding/on_boarding_repository.dart';
import '../repository/user/user_repository.dart';

@injectable
class CheckAppStartupUseCase {
  final OnBoardingRepository _boardingRepository;
  final UserRepository _userRepository;

  CheckAppStartupUseCase(this._boardingRepository, this._userRepository);

  StartupResult checkAppStartup() {
    var onBoardingResult = _boardingRepository.checkOnboarding();
    return onBoardingResult.fold(
      (failure) => StartupResult(StartupStatus.onboarding, null),
      (onboarding) {
        if (onboarding == true) {
          return StartupResult(StartupStatus.onboarding, null);
        } else {
          var userResult = _userRepository.getUserFromCache();
          return userResult.fold(
            (failure) => StartupResult(StartupStatus.unauthenticated, null),
            (result) {
              return result.fold(
                () => StartupResult(StartupStatus.unauthenticated, null),
                (myUser) => StartupResult(StartupStatus.authenticated, myUser),
              );
            },
          );
        }
      },
    );
  }
}
