// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:cryptography/cryptography.dart' as _i95;
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
import '../../data/data_sources/remote/account/account_remote_data_source.dart'
    as _i629;
import '../../data/data_sources/remote/account/impl/account_remote_data_source_impl.dart'
    as _i875;
import '../../data/data_sources/remote/auth/auth_remote_data_source.dart'
    as _i202;
import '../../data/data_sources/remote/auth/impl/auth_remote_data_source_impl.dart'
    as _i646;
import '../../data/data_sources/remote/user/impl/user_remote_data_source_impl.dart'
    as _i22;
import '../../data/data_sources/remote/user/user_remote_data_source.dart'
    as _i632;
import '../../data/repository/account/account_repository_impl.dart' as _i381;
import '../../data/repository/auth/auth_repository_impl.dart' as _i392;
import '../../data/repository/on_boarding/on_boarding_repository_impl.dart'
    as _i14;
import '../../data/repository/user/user_repository_impl.dart' as _i1053;
import '../../domain/repository/account/account_repository.dart' as _i406;
import '../../domain/repository/auth/auth_repository.dart' as _i912;
import '../../domain/repository/on_boarding/on_boarding_repository.dart'
    as _i977;
import '../../domain/repository/user/user_repository.dart' as _i183;
import '../../domain/repository/vault/vault_repository.dart' as _i402;
import '../../domain/use_cases/add_account_use_case.dart' as _i327;
import '../../domain/use_cases/check_app_startup_use_case.dart' as _i543;
import '../../domain/use_cases/delete_account_from_vault_use_case.dart'
    as _i202;
import '../../domain/use_cases/delete_account_use_case.dart' as _i1008;
import '../../domain/use_cases/get_accounts_use_case.dart' as _i941;
import '../../domain/use_cases/login_with_email_and_password_use_case.dart'
    as _i1065;
import '../../domain/use_cases/logout_use_case.dart' as _i250;
import '../../domain/use_cases/register_with_email_and_password_use_case.dart'
    as _i904;
import '../../domain/use_cases/reset_password_use_case.dart' as _i638;
import '../../domain/use_cases/set_master_password_use_case.dart' as _i756;
import '../../domain/use_cases/set_onboarding_done_use_case.dart' as _i551;
import '../../domain/use_cases/sign_in_with_google_use_cases.dart' as _i447;
import '../../domain/use_cases/update_account_details_use_case.dart' as _i274;
import '../../domain/use_cases/update_account_use_case.dart' as _i432;
import '../../domain/use_cases/vault/create_vault_verifier_use_case.dart'
    as _i246;
import '../../domain/use_cases/vault/decrypt_password_use_case.dart' as _i1001;
import '../../domain/use_cases/vault/encrypt_password_use_case.dart' as _i578;
import '../../domain/use_cases/vault/unlock_vault_use_case.dart' as _i1040;
import '../../features/auth/cubit/user_view_model.dart' as _i8;
import '../../features/home_screen/cubit/home_view_model.dart' as _i941;
import '../../features/master_password_screen/cubit/master_password_view_model.dart'
    as _i884;
import '../../features/onboarding_screen/provider/onboarding_view_model.dart'
    as _i926;
import '../../features/platform_account/cubit/platform_account_view_model.dart'
    as _i458;
import '../data_bases/cache/local_storage.dart' as _i1020;
import '../data_bases/cache/local_storage_module.dart' as _i2;
import '../data_bases/cache/shared_prefs_utils.dart' as _i1059;
import '../services/firebase_services/firebase_auth_service.dart' as _i286;
import '../services/firebase_services/firebase_module.dart' as _i971;
import '../services/firebase_services/firestore_service.dart' as _i75;
import '../services/vault_crypto_service/cryptography_module.dart' as _i128;
import '../services/vault_crypto_service/vault_crypto_service.dart' as _i515;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final localStorageModule = _$LocalStorageModule();
    final firebaseModule = _$FirebaseModule();
    final cryptographyModule = _$CryptographyModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => localStorageModule.sharedPreferences,
      preResolve: true,
    );
    gh.singleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.singleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.singleton<_i116.GoogleSignIn>(() => firebaseModule.googleSignIn);
    gh.singleton<_i95.Cryptography>(() => cryptographyModule.cryptography);
    gh.singleton<_i95.Pbkdf2>(() => cryptographyModule.pbkf2);
    gh.lazySingleton<_i75.FirestoreService>(
      () => _i75.FirestoreService(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i629.AccountRemoteDataSource>(
      () => _i875.AccountRemoteDataSourceImpl(gh<_i75.FirestoreService>()),
    );
    gh.factory<_i632.UserRemoteDataSource>(
      () => _i22.UserRemoteDataSourceImpl(gh<_i75.FirestoreService>()),
    );
    gh.factory<_i406.AccountRepository>(
      () => _i381.AccountRepositoryImpl(gh<_i629.AccountRemoteDataSource>()),
    );
    gh.factory<_i327.AddPlatformAccountUseCase>(
      () => _i327.AddPlatformAccountUseCase(gh<_i406.AccountRepository>()),
    );
    gh.factory<_i202.DeletePlatformAccountUseCase>(
      () => _i202.DeletePlatformAccountUseCase(gh<_i406.AccountRepository>()),
    );
    gh.factory<_i941.GetAccountsUseCase>(
      () => _i941.GetAccountsUseCase(gh<_i406.AccountRepository>()),
    );
    gh.factory<_i432.UpdatePlatformAccountUseCase>(
      () => _i432.UpdatePlatformAccountUseCase(gh<_i406.AccountRepository>()),
    );
    gh.lazySingleton<_i402.VaultRepository>(
      () =>
          _i515.VaultCryptoService(gh<_i95.Cryptography>(), gh<_i95.Pbkdf2>()),
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
    gh.factory<_i246.CreateVaultVerifierUseCase>(
      () => _i246.CreateVaultVerifierUseCase(gh<_i402.VaultRepository>()),
    );
    gh.factory<_i1001.DecryptPasswordUseCase>(
      () => _i1001.DecryptPasswordUseCase(gh<_i402.VaultRepository>()),
    );
    gh.factory<_i578.EncryptPasswordUseCase>(
      () => _i578.EncryptPasswordUseCase(gh<_i402.VaultRepository>()),
    );
    gh.factory<_i1040.UnlockVaultUseCase>(
      () => _i1040.UnlockVaultUseCase(gh<_i402.VaultRepository>()),
    );
    gh.factory<_i458.PlatformAccountCubit>(
      () => _i458.PlatformAccountCubit(
        gh<_i432.UpdatePlatformAccountUseCase>(),
        gh<_i202.DeletePlatformAccountUseCase>(),
        gh<_i327.AddPlatformAccountUseCase>(),
        gh<_i578.EncryptPasswordUseCase>(),
      ),
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
    gh.factory<_i941.HomeCubit>(
      () => _i941.HomeCubit(
        gh<_i941.GetAccountsUseCase>(),
        gh<_i1001.DecryptPasswordUseCase>(),
      ),
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
    gh.factory<_i1008.DeleteUserUseCase>(
      () => _i1008.DeleteUserUseCase(
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
    gh.factory<_i447.ContinueWithGoogleUseCases>(
      () => _i447.ContinueWithGoogleUseCases(gh<_i912.AuthRepository>()),
    );
    gh.factory<_i756.SetMasterPasswordUseCase>(
      () => _i756.SetMasterPasswordUseCase(gh<_i183.UserRepository>()),
    );
    gh.factory<_i274.UpdateUserDetailsUseCase>(
      () => _i274.UpdateUserDetailsUseCase(gh<_i183.UserRepository>()),
    );
    gh.factory<_i884.MasterPasswordCubit>(
      () => _i884.MasterPasswordCubit(
        gh<_i756.SetMasterPasswordUseCase>(),
        gh<_i246.CreateVaultVerifierUseCase>(),
        gh<_i1040.UnlockVaultUseCase>(),
      ),
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
    gh.lazySingleton<_i8.UserCubit>(
      () => _i8.UserCubit(
        gh<_i447.ContinueWithGoogleUseCases>(),
        gh<_i904.RegisterWithEmailAndPasswordUseCase>(),
        gh<_i1065.LoginWithEmailAndPasswordUseCase>(),
        gh<_i250.LogoutUseCase>(),
        gh<_i1008.DeleteUserUseCase>(),
        gh<_i274.UpdateUserDetailsUseCase>(),
        gh<_i638.ResetPasswordUseCase>(),
        gh<_i543.CheckAppStartupUseCase>(),
        gh<_i941.HomeCubit>(),
      ),
    );
    gh.factory<_i926.OnboardingViewModel>(
      () => _i926.OnboardingViewModel(gh<_i551.SetOnboardingDoneUseCase>()),
    );
    return this;
  }
}

class _$LocalStorageModule extends _i2.LocalStorageModule {}

class _$FirebaseModule extends _i971.FirebaseModule {}

class _$CryptographyModule extends _i128.CryptographyModule {}
