import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/failure/failure.dart';
import '../../../domain/repository/on_boarding/on_boarding_repository.dart';
import '../../data_sources/local/on_boarding/on_boarding_local_data_source.dart';
import '../../exceptions/app_exceptions.dart';
import '../../mapper/exception_mapper.dart';

@Injectable(as: OnBoardingRepository)
class OnBoardingRepositoryImpl implements OnBoardingRepository {
  final OnBoardingLocalDataSource _onBoardingLocalDataSource;

  OnBoardingRepositoryImpl(this._onBoardingLocalDataSource);

  @override
  Either<Failure, bool> checkOnboarding() {
    try {
      var onBoarding = _onBoardingLocalDataSource.checkOnboarding();
      return Right(onBoarding);
    } on AppException catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  void setOnboarding() {
    _onBoardingLocalDataSource.setOnboarding();
  }
}
