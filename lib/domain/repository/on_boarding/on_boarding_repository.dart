import 'package:dartz/dartz.dart';

import '../../failure/failure.dart';

abstract class OnBoardingRepository {
  Either<Failure, bool> checkOnboarding();

  void setOnboarding();
}
