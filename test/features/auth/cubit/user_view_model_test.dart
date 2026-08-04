import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/core/utils/app_routes.dart';
import 'package:pb_vault/domain/entities/response/user/my_user.dart';
import 'package:pb_vault/domain/entities/startup_result/startup_result.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/use_cases/check_app_startup_use_case.dart';
import 'package:pb_vault/domain/use_cases/delete_account_use_case.dart';
import 'package:pb_vault/domain/use_cases/login_with_email_and_password_use_case.dart';
import 'package:pb_vault/domain/use_cases/logout_use_case.dart';
import 'package:pb_vault/domain/use_cases/register_with_email_and_password_use_case.dart';
import 'package:pb_vault/domain/use_cases/reset_password_use_case.dart';
import 'package:pb_vault/domain/use_cases/sign_in_with_google_use_cases.dart';
import 'package:pb_vault/domain/use_cases/update_user_details_use_case.dart';
import 'package:pb_vault/features/auth/cubit/user_view_model.dart';
import 'package:pb_vault/features/auth/cubit/user_state.dart';
import 'package:pb_vault/features/home_screen/cubit/home_view_model.dart';
import 'package:pb_vault/features/home_screen/cubit/home_state.dart';
import 'package:pb_vault/features/master_password_screen/cubit/master_password_view_model.dart';
import 'package:pb_vault/features/master_password_screen/cubit/master_password_state.dart';

class MockContinueWithGoogleUseCases extends Mock
    implements ContinueWithGoogleUseCases {}

class MockRegisterWithEmailAndPasswordUseCase extends Mock
    implements RegisterWithEmailAndPasswordUseCase {}

class MockLoginWithEmailAndPasswordUseCase extends Mock
    implements LoginWithEmailAndPasswordUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockDeleteUserUseCase extends Mock implements DeleteUserUseCase {}

class MockUpdateUserDetailsUseCase extends Mock
    implements UpdateUserDetailsUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class MockCheckAppStartupUseCase extends Mock
    implements CheckAppStartupUseCase {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockMasterPasswordCubit extends MockCubit<MasterPasswordState>
    implements MasterPasswordCubit {}

void main() {
  late UserCubit cubit;
  late MockContinueWithGoogleUseCases mockSignInWithGoogleUseCases;
  late MockRegisterWithEmailAndPasswordUseCase
      mockRegisterWithEmailAndPasswordUseCases;
  late MockLoginWithEmailAndPasswordUseCase mockLoginWithEmailAndPasswordUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockDeleteUserUseCase mockDeleteAccountUseCase;
  late MockUpdateUserDetailsUseCase mockUpdateUserDetailsUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;
  late MockCheckAppStartupUseCase mockCheckAppStartupUseCase;
  late MockHomeCubit mockHomeCubit;
  late MockMasterPasswordCubit mockMasterPasswordCubit;

  const tUser = MyUser(
    id: '1',
    email: 'test@example.com',
    name: 'Test',
    provider: 'email',
  );

  setUpAll(() {
    registerFallbackValue(tUser);
  });

  setUp(() {
    mockSignInWithGoogleUseCases = MockContinueWithGoogleUseCases();
    mockRegisterWithEmailAndPasswordUseCases =
        MockRegisterWithEmailAndPasswordUseCase();
    mockLoginWithEmailAndPasswordUseCase =
        MockLoginWithEmailAndPasswordUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockDeleteAccountUseCase = MockDeleteUserUseCase();
    mockUpdateUserDetailsUseCase = MockUpdateUserDetailsUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();
    mockCheckAppStartupUseCase = MockCheckAppStartupUseCase();
    mockHomeCubit = MockHomeCubit();
    mockMasterPasswordCubit = MockMasterPasswordCubit();

    // Default stub for MasterPasswordCubit stream to avoid issues during construction
    when(() => mockMasterPasswordCubit.stream)
        .thenAnswer((_) => const Stream.empty());

    cubit = UserCubit(
      mockSignInWithGoogleUseCases,
      mockRegisterWithEmailAndPasswordUseCases,
      mockLoginWithEmailAndPasswordUseCase,
      mockLogoutUseCase,
      mockDeleteAccountUseCase,
      mockUpdateUserDetailsUseCase,
      mockResetPasswordUseCase,
      mockCheckAppStartupUseCase,
      mockHomeCubit,
      mockMasterPasswordCubit,
    );
  });

  group('loginWithEmailAndPassword', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password';

    blocTest<UserCubit, UserState>(
      'should emit [LoginWithEmailPasswordLoadingState, UserAuthenticatedState] when success',
      build: () {
        when(() => mockLoginWithEmailAndPasswordUseCase.invoke(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Right(tUser));
        return cubit;
      },
      act: (cubit) => cubit.loginWithEmailAndPassword(tEmail, tPassword),
      expect: () => [
        isA<LoginWithEmailPasswordLoadingState>(),
        isA<UserAuthenticatedState>()
            .having((s) => s.currentUser, 'user', tUser),
      ],
      verify: (_) {
        verify(() => mockLoginWithEmailAndPasswordUseCase.invoke(
              email: tEmail,
              password: tPassword,
            )).called(1);
        expect(cubit.currentUser, tUser);
      },
    );

    blocTest<UserCubit, UserState>(
      'should emit [LoginWithEmailPasswordLoadingState, LoginWithEmailPasswordErrorState] when failure',
      build: () {
        when(() => mockLoginWithEmailAndPasswordUseCase.invoke(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Left(ServerFailure('error_key')));
        return cubit;
      },
      act: (cubit) => cubit.loginWithEmailAndPassword(tEmail, tPassword),
      expect: () => [
        isA<LoginWithEmailPasswordLoadingState>(),
        isA<LoginWithEmailPasswordErrorState>(),
      ],
    );
  });

  group('registerWithEmailAndPassword', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password';
    const tName = 'Name';
    const tAvatarIndex = 1;

    blocTest<UserCubit, UserState>(
      'should emit [RegisterWithEmailPasswordLoadingState, UserAuthenticatedState] when success',
      build: () {
        when(() => mockRegisterWithEmailAndPasswordUseCases.invoke(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
              avatarIndex: any(named: 'avatarIndex'),
            )).thenAnswer((_) async => const Right(tUser));
        return cubit;
      },
      act: (cubit) => cubit.registerWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        name: tName,
        avatarIndex: tAvatarIndex,
      ),
      expect: () => [
        isA<RegisterWithEmailPasswordLoadingState>(),
        isA<UserAuthenticatedState>(),
      ],
      verify: (_) {
        expect(cubit.isAccountJustCreated, true);
        expect(cubit.currentUser, tUser);
      },
    );

    blocTest<UserCubit, UserState>(
      'should emit [RegisterWithEmailPasswordLoadingState, RegisterWithEmailPasswordErrorState] when failure',
      build: () {
        when(() => mockRegisterWithEmailAndPasswordUseCases.invoke(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
          avatarIndex: any(named: 'avatarIndex'),
        )).thenAnswer(
              (_) async => const Left(ServerFailure('error')),
        );

        return cubit;
      },
      act: (cubit) => cubit.registerWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        name: tName,
        avatarIndex: tAvatarIndex,
      ),
      expect: () => [
        isA<RegisterWithEmailPasswordLoadingState>(),
        isA<RegisterWithEmailPasswordErrorState>(),
      ],
    );
  });

  group('continueWithGoogle', () {
    blocTest<UserCubit, UserState>(
      'should emit [ContinueWithGoogleLoadingState, UserAuthenticatedState] when success',
      build: () {
        when(() => mockSignInWithGoogleUseCases.invoke())
            .thenAnswer((_) async => const Right(tUser));
        return cubit;
      },
      act: (cubit) => cubit.continueWithGoogle(),
      expect: () => [
        isA<ContinueWithGoogleLoadingState>(),
        isA<UserAuthenticatedState>(),
      ],
    );

    blocTest<UserCubit, UserState>(
      'should emit [ContinueWithGoogleLoadingState, ContinueWithGoogleErrorState] when failure',
      build: () {
        when(() => mockSignInWithGoogleUseCases.invoke())
            .thenAnswer((_) async => const Left(ServerFailure('error')));

        return cubit;
      },
      act: (cubit) => cubit.continueWithGoogle(),
      expect: () => [
        isA<ContinueWithGoogleLoadingState>(),
        isA<ContinueWithGoogleErrorState>(),
      ],
    );
  });

  group('logout', () {
    blocTest<UserCubit, UserState>(
      'should emit [LogoutLoadingState, UserUnauthenticatedState] and clear state when success',
      build: () {
        cubit.currentUser = tUser;
        cubit.isAccountJustCreated = true;
        when(() => mockLogoutUseCase.invoke())
            .thenAnswer((_) async => const Right(unit));
        when(() => mockMasterPasswordCubit.lockVault()).thenReturn(null);
        when(() => mockHomeCubit.clearHomeAccounts())
            .thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<LogoutLoadingState>(),
        isA<UserUnauthenticatedState>(),
      ],
      verify: (_) {
        verify(() => mockMasterPasswordCubit.lockVault()).called(1);
        verify(() => mockHomeCubit.clearHomeAccounts()).called(1);
        expect(cubit.currentUser, null);
        expect(cubit.isAccountJustCreated, false);
      },
    );

    blocTest<UserCubit, UserState>(
      'should emit [LogoutLoadingState, LogoutErrorState] when logout fails',
      build: () {
        when(() => mockLogoutUseCase.invoke())
            .thenAnswer((_) async => const Left(ServerFailure('error')));

        return cubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<LogoutLoadingState>(),
        isA<LogoutErrorState>(),
      ],
      verify: (_) {
        verifyNever(() => mockMasterPasswordCubit.lockVault());
        verifyNever(() => mockHomeCubit.clearHomeAccounts());
      },
    );
  });

  group('deleteUser', () {
    blocTest<UserCubit, UserState>(
      'should emit [UserDeleteLoadingState, UserDeleteSuccessState] and logout when success',
      build: () {
        cubit.currentUser = tUser;
        when(() => mockDeleteAccountUseCase.invoke(
              password: any(named: 'password'),
              provider: any(named: 'provider'),
            )).thenAnswer((_) async => const Right(unit));
        // Mock logout success inside deleteUser
        when(() => mockLogoutUseCase.invoke())
            .thenAnswer((_) async => const Right(unit));
        when(() => mockMasterPasswordCubit.lockVault()).thenReturn(null);
        when(() => mockHomeCubit.clearHomeAccounts())
            .thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.deleteUser(password: 'password'),
      expect: () => [
        isA<UserDeleteLoadingState>(),
        isA<UserDeleteSuccessState>(),
        isA<LogoutLoadingState>(),
        isA<UserUnauthenticatedState>(),
      ],
    );
    blocTest<UserCubit, UserState>(
      'should emit [UserDeleteLoadingState, UserDeleteErrorState] when delete fails',
      build: () {
        cubit.currentUser = tUser;

        when(() => mockDeleteAccountUseCase.invoke(
          password: any(named: 'password'),
          provider: any(named: 'provider'),
        )).thenAnswer(
              (_) async => const Left(ServerFailure('error')),
        );

        return cubit;
      },
      act: (cubit) => cubit.deleteUser(password: 'password'),
      expect: () => [
        isA<UserDeleteLoadingState>(),
        isA<UserDeleteErrorState>(),
      ],
    );
  });

  group('updateUserDetails', () {
    blocTest<UserCubit, UserState>(
      'should emit [UserDetailsUpdateLoadingState, UserDetailsUpdateSuccessState] when success',
      build: () {
        when(() => mockUpdateUserDetailsUseCase.updateAccountDetails(
              user: any(named: 'user'),
            )).thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) => cubit.updateUserDetails(user: tUser),
      expect: () => [
        isA<UserDetailsUpdateLoadingState>(),
        isA<UserDetailsUpdateSuccessState>(),
      ],
      verify: (_) {
        expect(cubit.currentUser, tUser);
      },
    );

    blocTest<UserCubit, UserState>(
      'should emit [UserDetailsUpdateLoadingState, UserDetailsUpdateErrorState] when failure',
      build: () {
        when(() => mockUpdateUserDetailsUseCase.updateAccountDetails(
          user: any(named: 'user'),
        )).thenAnswer(
              (_) async => const Left(ServerFailure('error')),
        );

        return cubit;
      },
      act: (cubit) => cubit.updateUserDetails(user: tUser),
      expect: () => [
        isA<UserDetailsUpdateLoadingState>(),
        isA<UserDetailsUpdateErrorState>(),
      ],
    );
  });

  group('resetPassword', () {
    blocTest<UserCubit, UserState>(
      'should emit [ResetUSerPasswordLoadingState, ResetUserPasswordSuccessState] when success',
      build: () {
        when(() => mockResetPasswordUseCase.invoke(email: any(named: 'email')))
            .thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) => cubit.resetPassword(email: 'test@example.com'),
      expect: () => [
        isA<ResetUSerPasswordLoadingState>(),
        isA<ResetUserPasswordSuccessState>(),
      ],
    );

    blocTest<UserCubit, UserState>(
      'should emit [ResetUSerPasswordLoadingState, ResetUSerPasswordErrorState] when failure',
      build: () {
        when(() => mockResetPasswordUseCase.invoke(
          email: any(named: 'email'),
        )).thenAnswer(
              (_) async => const Left(ServerFailure('error')),
        );

        return cubit;
      },
      act: (cubit) => cubit.resetPassword(email: 'test@example.com'),
      expect: () => [
        isA<ResetUSerPasswordLoadingState>(),
        isA<ResetUSerPasswordErrorState>(),
      ],
    );
  });

  group('changeUser', () {
    blocTest<UserCubit, UserState>(
      'should update currentUser and emit UserAuthenticatedState',
      build: () => cubit,
      act: (cubit) => cubit.changeUser(tUser),
      expect: () => [
        isA<UserAuthenticatedState>()
            .having((s) => s.currentUser, 'user', tUser),
      ],
      verify: (_) {
        expect(cubit.currentUser, tUser);
      },
    );
    test('should ignore non success master password states', () async {
      final controller = StreamController<MasterPasswordState>();

      when(() => mockMasterPasswordCubit.stream)
          .thenAnswer((_) => controller.stream);

      cubit = UserCubit(
        mockSignInWithGoogleUseCases,
        mockRegisterWithEmailAndPasswordUseCases,
        mockLoginWithEmailAndPasswordUseCase,
        mockLogoutUseCase,
        mockDeleteAccountUseCase,
        mockUpdateUserDetailsUseCase,
        mockResetPasswordUseCase,
        mockCheckAppStartupUseCase,
        mockHomeCubit,
        mockMasterPasswordCubit,
      );

      controller.add(ChangeMasterPasswordLoading());

      await Future.delayed(Duration.zero);

      expect(cubit.currentUser, isNull);

      await controller.close();
    });
  });

  group('getInitialRoute', () {
    test('should return onboardingRouteName when StartupStatus.onboarding', () {
      when(() => mockCheckAppStartupUseCase.checkAppStartup())
          .thenReturn(StartupResult(StartupStatus.onboarding, null));

      final result = cubit.getInitialRoute();

      expect(result, AppRoutes.onboardingRouteName);
    });

    test('should return authScreen when StartupStatus.unauthenticated', () {
      when(() => mockCheckAppStartupUseCase.checkAppStartup())
          .thenReturn(StartupResult(StartupStatus.unauthenticated, null));

      final result = cubit.getInitialRoute();

      expect(result, AppRoutes.authScreen);
    });

    test(
        'should return masterPasswordScreen and set user when StartupStatus.authenticated',
        () {
      when(() => mockCheckAppStartupUseCase.checkAppStartup())
          .thenReturn(StartupResult(StartupStatus.authenticated, tUser));

      final result = cubit.getInitialRoute();

      expect(result, AppRoutes.masterPasswordScreen);
      expect(cubit.currentUser, tUser);
    });
  });

  group('MasterPasswordCubit listener', () {
    test('should call changeUser when ChangeMasterPasswordSuccess is emitted',
        () async {
      final masterPasswordCubitStream = StreamController<MasterPasswordState>();
      when(() => mockMasterPasswordCubit.stream)
          .thenAnswer((_) => masterPasswordCubitStream.stream);

      // Re-create cubit to use the new stream
      cubit = UserCubit(
        mockSignInWithGoogleUseCases,
        mockRegisterWithEmailAndPasswordUseCases,
        mockLoginWithEmailAndPasswordUseCase,
        mockLogoutUseCase,
        mockDeleteAccountUseCase,
        mockUpdateUserDetailsUseCase,
        mockResetPasswordUseCase,
        mockCheckAppStartupUseCase,
        mockHomeCubit,
        mockMasterPasswordCubit,
      );

      masterPasswordCubitStream.add(ChangeMasterPasswordSuccess(tUser));

      // Wait for stream event
      await Future.delayed(Duration.zero);

      expect(cubit.currentUser, tUser);

      await masterPasswordCubitStream.close();
    });
  });
}
