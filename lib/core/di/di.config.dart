// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../data/data_sources/local/on_boarding/impl/on_boarding_local_data_source_impl.dart'
    as _i434;
import '../../data/data_sources/local/on_boarding/on_boarding_local_data_source.dart'
    as _i54;
import '../../data/data_sources/local/user/impl/user_local_data_source_impl.dart'
    as _i111;
import '../../data/data_sources/local/user/user_local_data_source.dart'
    as _i996;
import '../../data/data_sources/remote/auth/auth_remote_data_source.dart'
    as _i202;
import '../../data/data_sources/remote/auth/impl/auth_remote_data_source_impl.dart'
    as _i646;
import '../../data/data_sources/remote/user/impl/user_remote_data_source_impl.dart'
    as _i22;
import '../../data/data_sources/remote/user/user_remote_data_source.dart'
    as _i632;
import '../../data/repository/auth/auth_repository_impl.dart' as _i392;
import '../../data/repository/on_boarding/on_boarding_repository_impl.dart'
    as _i14;
import '../../data/repository/user/user_repository_impl.dart' as _i1053;
import '../../domain/repository/auth/auth_repository.dart' as _i912;
import '../../domain/repository/on_boarding/on_boarding_repository.dart'
    as _i977;
import '../../domain/repository/user/user_repository.dart' as _i183;
import '../../domain/use_cases/check_app_startup_use_case.dart' as _i543;
import '../../domain/use_cases/delete_account_use_case.dart' as _i1008;
import '../../domain/use_cases/login_with_email_and_password_use_case.dart'
    as _i1065;
import '../../domain/use_cases/logout_use_case.dart' as _i250;
import '../../domain/use_cases/register_with_email_and_password_use_case.dart'
    as _i904;
import '../../domain/use_cases/reset_password_use_case.dart' as _i638;
import '../../domain/use_cases/set_onboarding_done_use_case.dart' as _i551;
import '../../domain/use_cases/sign_in_with_google_use_cases.dart' as _i447;
import '../../domain/use_cases/update_account_details_use_case.dart' as _i274;
import '../../features/auth/cubit/auth_view_model.dart' as _i260;
import '../data_bases/cache/local_storage.dart' as _i1020;
import '../data_bases/cache/local_storage_module.dart' as _i2;
import '../data_bases/cache/shared_prefs_utils.dart' as _i1059;
import '../services/firebase_services/firebase_auth_service.dart' as _i286;
import '../services/firebase_services/firebase_module.dart' as _i971;
import '../services/firebase_services/firestore_service.dart' as _i75;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final localStorageModule = _$LocalStorageModule();
    final firebaseModule = _$FirebaseModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => localStorageModule.sharedPreferences,
      preResolve: true,
    );
    gh.singleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.singleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.singleton<_i116.GoogleSignIn>(() => firebaseModule.googleSignIn);
    gh.lazySingleton<_i75.FirestoreService>(
      () => _i75.FirestoreService(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i632.UserRemoteDataSource>(
      () => _i22.UserRemoteDataSourceImpl(gh<_i75.FirestoreService>()),
    );
    gh.lazySingleton<_i1059.SharedPrefsUtils>(
      () => _i1059.SharedPrefsUtils(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i286.FirebaseAuthService>(
      () => _i286.FirebaseAuthService(
        gh<_i59.FirebaseAuth>(),
        gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.lazySingleton<_i1020.LocalStorage>(
      () => _i1020.LocalStorage(gh<_i1059.SharedPrefsUtils>()),
    );
    gh.factory<_i202.AuthRemoteDataSource>(
      () => _i646.AuthRemoteDataSourceImpl(gh<_i286.FirebaseAuthService>()),
    );
    gh.factory<_i996.UserLocalDataSource>(
      () => _i111.UserLocalDataSourceImpl(gh<_i1020.LocalStorage>()),
    );
    gh.factory<_i912.AuthRepository>(
      () => _i392.AuthRepositoryImpl(
        gh<_i202.AuthRemoteDataSource>(),
        gh<_i632.UserRemoteDataSource>(),
        gh<_i996.UserLocalDataSource>(),
      ),
    );
    gh.factory<_i250.LogoutUseCase>(
      () => _i250.LogoutUseCase(gh<_i912.AuthRepository>()),
    );
    gh.factory<_i638.ResetPasswordUseCase>(
      () => _i638.ResetPasswordUseCase(gh<_i912.AuthRepository>()),
    );
    gh.factory<_i183.UserRepository>(
      () => _i1053.UserRepositoryImpl(
        gh<_i632.UserRemoteDataSource>(),
        gh<_i996.UserLocalDataSource>(),
      ),
    );
    gh.factory<_i54.OnBoardingLocalDataSource>(
      () => _i434.OnBoardingLocalDataSourceImpl(gh<_i1020.LocalStorage>()),
    );
    gh.factory<_i1008.DeleteAccountUseCase>(
      () => _i1008.DeleteAccountUseCase(
        gh<_i183.UserRepository>(),
        gh<_i912.AuthRepository>(),
      ),
    );
    gh.factory<_i977.OnBoardingRepository>(
      () => _i14.OnBoardingRepositoryImpl(gh<_i54.OnBoardingLocalDataSource>()),
    );
    gh.factory<_i1065.LoginWithEmailAndPasswordUseCase>(
      () => _i1065.LoginWithEmailAndPasswordUseCase(gh<_i912.AuthRepository>()),
    );
    gh.factory<_i904.RegisterWithEmailAndPasswordUseCase>(
      () =>
          _i904.RegisterWithEmailAndPasswordUseCase(gh<_i912.AuthRepository>()),
    );
    gh.factory<_i447.SignInWithGoogleUseCases>(
      () => _i447.SignInWithGoogleUseCases(gh<_i912.AuthRepository>()),
    );
    gh.factory<_i274.UpdateAccountDetailsUseCase>(
      () => _i274.UpdateAccountDetailsUseCase(gh<_i183.UserRepository>()),
    );
    gh.factory<_i551.SetOnboardingDoneUseCase>(
      () => _i551.SetOnboardingDoneUseCase(gh<_i977.OnBoardingRepository>()),
    );
    gh.factory<_i543.CheckAppStartupUseCase>(
      () => _i543.CheckAppStartupUseCase(
        gh<_i977.OnBoardingRepository>(),
        gh<_i183.UserRepository>(),
      ),
    );
    gh.lazySingleton<_i260.AuthCubit>(
      () => _i260.AuthCubit(
        gh<_i447.SignInWithGoogleUseCases>(),
        gh<_i904.RegisterWithEmailAndPasswordUseCase>(),
        gh<_i1065.LoginWithEmailAndPasswordUseCase>(),
        gh<_i250.LogoutUseCase>(),
        gh<_i1008.DeleteAccountUseCase>(),
        gh<_i274.UpdateAccountDetailsUseCase>(),
        gh<_i638.ResetPasswordUseCase>(),
        gh<_i543.CheckAppStartupUseCase>(),
      ),
    );
    return this;
  }
}

class _$LocalStorageModule extends _i2.LocalStorageModule {}

class _$FirebaseModule extends _i971.FirebaseModule {}
