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
import 'package:pb_vault/features/auth/cubit/user_state.dart';
import 'package:pb_vault/features/auth/cubit/user_view_model.dart';
import 'package:pb_vault/features/home_screen/cubit/home_state.dart';
import 'package:pb_vault/features/home_screen/cubit/home_view_model.dart';
import 'package:pb_vault/features/master_password_screen/cubit/master_password_state.dart';
import 'package:pb_vault/features/master_password_screen/cubit/master_password_view_model.dart';

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
  late UserCubit userCubit;
  late MockContinueWithGoogleUseCases mockSignInWithGoogleUseCases;
  late MockRegisterWithEmailAndPasswordUseCase
  mockRegisterWithEmailAndPasswordUseCases;
  late MockLoginWithEmailAndPasswordUseCase
  mockLoginWithEmailAndPasswordUseCase;
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
    name: 'Test User',
    provider: 'email',
  );
  const tFailure = ServerFailure('error_message');

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

    userCubit = UserCubit(
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

  tearDown(() {
    userCubit.close();
  });

  test('initial state should be UserInitial', () {
    expect(userCubit.state, isA<UserInitial>());
  });

  group('loginWithEmailAndPassword', () {
    blocTest<UserCubit, UserState>(
      'emits [LoginWithEmailPasswordLoadingState, UserAuthenticatedState] when successful',
      build: () {
        when(
          () => mockLoginWithEmailAndPasswordUseCase.invoke(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(tUser));
        return userCubit;
      },
      act: (cubit) => cubit.loginWithEmailAndPassword('email', 'password'),
      expect: () => [
        isA<LoginWithEmailPasswordLoadingState>(),
        isA<UserAuthenticatedState>().having(
          (s) => s.currentUser,
          'currentUser',
          tUser,
        ),
      ],
      verify: (cubit) {
        expect(cubit.currentUser, tUser);
        verify(
          () => mockLoginWithEmailAndPasswordUseCase.invoke(
            email: 'email',
            password: 'password',
          ),
        ).called(1);
        verifyNoMoreInteractions(mockLoginWithEmailAndPasswordUseCase);
      },
    );

    blocTest<UserCubit, UserState>(
      'emits [LoginWithEmailPasswordLoadingState, LoginWithEmailPasswordErrorState] when failure',
      build: () {
        when(
          () => mockLoginWithEmailAndPasswordUseCase.invoke(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));
        return userCubit;
      },
      act: (cubit) => cubit.loginWithEmailAndPassword('email', 'password'),
      expect: () => [
        isA<LoginWithEmailPasswordLoadingState>(),
        isA<LoginWithEmailPasswordErrorState>().having(
          (s) => s.message,
          'message',
          'error_message',
        ),
      ],
      verify: (_) {
        verify(
          () => mockLoginWithEmailAndPasswordUseCase.invoke(
            email: 'email',
            password: 'password',
          ),
        ).called(1);
        verifyNoMoreInteractions(mockLoginWithEmailAndPasswordUseCase);
      },
    );
  });

  group('registerWithEmailAndPassword', () {
    blocTest<UserCubit, UserState>(
      'emits [RegisterWithEmailPasswordLoadingState, UserAuthenticatedState] when successful',
      build: () {
        when(
          () => mockRegisterWithEmailAndPasswordUseCases.invoke(
            email: any(named: 'email'),
            password: any(named: 'password'),
            name: any(named: 'name'),
            avatarIndex: any(named: 'avatarIndex'),
          ),
        ).thenAnswer((_) async => const Right(tUser));
        return userCubit;
      },
      act: (cubit) => cubit.registerWithEmailAndPassword(
        email: 'email',
        password: 'password',
        name: 'name',
        avatarIndex: 0,
      ),
      expect: () => [
        isA<RegisterWithEmailPasswordLoadingState>(),
        isA<UserAuthenticatedState>().having(
          (s) => s.currentUser,
          'currentUser',
          tUser,
        ),
      ],
      verify: (cubit) {
        expect(cubit.currentUser, tUser);
        verify(
          () => mockRegisterWithEmailAndPasswordUseCases.invoke(
            email: 'email',
            password: 'password',
            name: 'name',
            avatarIndex: 0,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRegisterWithEmailAndPasswordUseCases);
      },
    );

    blocTest<UserCubit, UserState>(
      'emits [RegisterWithEmailPasswordLoadingState, RegisterWithEmailPasswordErrorState] when failure',
      build: () {
        when(
          () => mockRegisterWithEmailAndPasswordUseCases.invoke(
            email: any(named: 'email'),
            password: any(named: 'password'),
            name: any(named: 'name'),
            avatarIndex: any(named: 'avatarIndex'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));
        return userCubit;
      },
      act: (cubit) => cubit.registerWithEmailAndPassword(
        email: 'email',
        password: 'password',
        name: 'name',
        avatarIndex: 0,
      ),
      expect: () => [
        isA<RegisterWithEmailPasswordLoadingState>(),
        isA<RegisterWithEmailPasswordErrorState>().having(
          (s) => s.message,
          'message',
          'error_message',
        ),
      ],
      verify: (_) {
        verify(
          () => mockRegisterWithEmailAndPasswordUseCases.invoke(
            email: 'email',
            password: 'password',
            name: 'name',
            avatarIndex: 0,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRegisterWithEmailAndPasswordUseCases);
      },
    );
  });

  group('continueWithGoogle', () {
    blocTest<UserCubit, UserState>(
      'emits [ContinueWithGoogleLoadingState, UserAuthenticatedState] when successful',
      build: () {
        when(
          () => mockSignInWithGoogleUseCases.invoke(),
        ).thenAnswer((_) async => const Right(tUser));
        return userCubit;
      },
      act: (cubit) => cubit.continueWithGoogle(),
      expect: () => [
        isA<ContinueWithGoogleLoadingState>(),
        isA<UserAuthenticatedState>().having(
          (s) => s.currentUser,
          'currentUser',
          tUser,
        ),
      ],
      verify: (cubit) {
        expect(cubit.currentUser, tUser);
        verify(() => mockSignInWithGoogleUseCases.invoke()).called(1);
        verifyNoMoreInteractions(mockSignInWithGoogleUseCases);
      },
    );

    blocTest<UserCubit, UserState>(
      'emits [ContinueWithGoogleLoadingState, ContinueWithGoogleErrorState] when failure',
      build: () {
        when(
          () => mockSignInWithGoogleUseCases.invoke(),
        ).thenAnswer((_) async => const Left(tFailure));
        return userCubit;
      },
      act: (cubit) => cubit.continueWithGoogle(),
      expect: () => [
        isA<ContinueWithGoogleLoadingState>(),
        isA<ContinueWithGoogleErrorState>().having(
          (s) => s.message,
          'message',
          'error_message',
        ),
      ],
      verify: (_) {
        verify(() => mockSignInWithGoogleUseCases.invoke()).called(1);
        verifyNoMoreInteractions(mockSignInWithGoogleUseCases);
      },
    );
  });

  group('logout', () {
    blocTest<UserCubit, UserState>(
      'emits [LogoutLoadingState, UserUnauthenticatedState] when successful',
      build: () {
        when(
          () => mockHomeCubit.clearHomeAccounts(),
        ).thenAnswer((_) async => {});
        when(
          () => mockLogoutUseCase.invoke(),
        ).thenAnswer((_) async => const Right(unit));
        return userCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<LogoutLoadingState>(),
        isA<UserUnauthenticatedState>(),
      ],
      verify: (_) {
        verify(() => mockHomeCubit.clearHomeAccounts()).called(1);
        verify(() => mockMasterPasswordCubit.lockVault()).called(1);
        verify(() => mockLogoutUseCase.invoke()).called(1);
        verifyNoMoreInteractions(mockHomeCubit);
        verifyNoMoreInteractions(mockLogoutUseCase);
        verifyNoMoreInteractions(mockMasterPasswordCubit);
      },
    );

    blocTest<UserCubit, UserState>(
      'emits [LogoutLoadingState, LogoutErrorState] when failure',
      build: () {

        when(
          () => mockLogoutUseCase.invoke(),
        ).thenAnswer((_) async => const Left(tFailure));
        return userCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<LogoutLoadingState>(),
        isA<LogoutErrorState>().having(
          (s) => s.message,
          'message',
          'error_message',
        ),
      ],
      verify: (_) {
        verify(() => mockLogoutUseCase.invoke()).called(1);
        verifyNoMoreInteractions(mockLogoutUseCase);
        verifyZeroInteractions(mockMasterPasswordCubit);
        verifyZeroInteractions(mockHomeCubit);
      },
    );
  });

  group('deleteUser', () {
    blocTest<UserCubit, UserState>(
      'emits success states when successful',
      build: () {
        userCubit.currentUser = tUser;
        when(
          () => mockDeleteAccountUseCase.invoke(
            password: any(named: 'password'),
            provider: any(named: 'provider'),
          ),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockLogoutUseCase.invoke(),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockHomeCubit.clearHomeAccounts(),
        ).thenAnswer((_) async => {});
        return userCubit;
      },
      act: (cubit) => cubit.deleteUser(password: 'password'),
      expect: () => [
        isA<UserDeleteLoadingState>(),
        isA<UserDeleteSuccessState>(),
        isA<LogoutLoadingState>(),
        isA<UserUnauthenticatedState>(),
      ],
      verify: (_) {
        verify(
          () => mockDeleteAccountUseCase.invoke(
            password: 'password',
            provider: tUser.provider,
          ),
        ).called(1);
        verify(() => mockLogoutUseCase.invoke()).called(1);
        verify(() => mockHomeCubit.clearHomeAccounts()).called(1);

        verifyNoMoreInteractions(mockDeleteAccountUseCase);
        verifyNoMoreInteractions(mockLogoutUseCase);
        verifyNoMoreInteractions(mockHomeCubit);
      },
    );

    blocTest<UserCubit, UserState>(
      'emits UserDeleteErrorState when failure',
      build: () {
        userCubit.currentUser = tUser;
        when(
          () => mockDeleteAccountUseCase.invoke(
            password: any(named: 'password'),
            provider: any(named: 'provider'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));
        return userCubit;
      },
      act: (cubit) => cubit.deleteUser(password: 'password'),
      expect: () => [
        isA<UserDeleteLoadingState>(),
        isA<UserDeleteErrorState>().having(
          (s) => s.message,
          'message',
          'error_message',
        ),
      ],
      verify: (_) {
        verify(
          () => mockDeleteAccountUseCase.invoke(
            password: 'password',
            provider: tUser.provider,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockDeleteAccountUseCase);
        verifyZeroInteractions(mockLogoutUseCase);
        verifyZeroInteractions(mockHomeCubit);
      },
    );
  });

  group('updateUserDetails', () {
    blocTest<UserCubit, UserState>(
      'emits [UserDetailsUpdateLoadingState, UserDetailsUpdateSuccessState] and updates currentUser on success',
      build: () {
        when(
          () => mockUpdateUserDetailsUseCase.updateAccountDetails(user: tUser),
        ).thenAnswer((_) async => const Right(unit));
        return userCubit;
      },
      act: (cubit) => cubit.updateUserDetails(user: tUser),
      expect: () => [
        isA<UserDetailsUpdateLoadingState>(),
        isA<UserDetailsUpdateSuccessState>(),
      ],
      verify: (cubit) {
        expect(cubit.currentUser, tUser);
        verify(
          () => mockUpdateUserDetailsUseCase.updateAccountDetails(user: tUser),
        ).called(1);
        verifyNoMoreInteractions(mockUpdateUserDetailsUseCase);
      },
    );

    blocTest<UserCubit, UserState>(
      'emits [UserDetailsUpdateLoadingState, USerDetailsUpdateErrorState] when failure',
      build: () {
        when(
          () => mockUpdateUserDetailsUseCase.updateAccountDetails(user: tUser),
        ).thenAnswer((_) async => const Left(tFailure));
        return userCubit;
      },
      act: (cubit) => cubit.updateUserDetails(user: tUser),
      expect: () => [
        isA<UserDetailsUpdateLoadingState>(),
        isA<UserDetailsUpdateErrorState>().having(
          (s) => s.message,
          'message',
          'error_message',
        ),
      ],
      verify: (_) {
        verify(
          () => mockUpdateUserDetailsUseCase.updateAccountDetails(user: tUser),
        ).called(1);
        verifyNoMoreInteractions(mockUpdateUserDetailsUseCase);
      },
    );
  });

  group('resetPassword', () {
    blocTest<UserCubit, UserState>(
      'emits [ResetUSerPasswordLoadingState, ResetUserPasswordSuccessState] on success',
      build: () {
        when(
          () => mockResetPasswordUseCase.invoke(email: any(named: 'email')),
        ).thenAnswer((_) async => const Right(unit));
        return userCubit;
      },
      act: (cubit) => cubit.resetPassword(email: 'test@example.com'),
      expect: () => [
        isA<ResetUSerPasswordLoadingState>(),
        isA<ResetUserPasswordSuccessState>(),
      ],
      verify: (_) {
        verify(
          () => mockResetPasswordUseCase.invoke(email: 'test@example.com'),
        ).called(1);
        verifyNoMoreInteractions(mockResetPasswordUseCase);
      },
    );

    blocTest<UserCubit, UserState>(
      'emits [ResetUSerPasswordLoadingState, ResetUSerPasswordErrorState] on failure',
      build: () {
        when(
          () => mockResetPasswordUseCase.invoke(email: any(named: 'email')),
        ).thenAnswer((_) async => const Left(tFailure));
        return userCubit;
      },
      act: (cubit) => cubit.resetPassword(email: 'test@example.com'),
      expect: () => [
        isA<ResetUSerPasswordLoadingState>(),
        isA<ResetUSerPasswordErrorState>().having(
          (s) => s.message,
          'message',
          'error_message',
        ),
      ],
      verify: (_) {
        verify(
          () => mockResetPasswordUseCase.invoke(email: 'test@example.com'),
        ).called(1);
        verifyNoMoreInteractions(mockResetPasswordUseCase);
      },
    );
  });

  group('getInitialRoute', () {
    test('returns onboarding route when status is onboarding', () {
      when(
        () => mockCheckAppStartupUseCase.checkAppStartup(),
      ).thenReturn(StartupResult(StartupStatus.onboarding, null));

      final route = userCubit.getInitialRoute();
      expect(route, AppRoutes.onboardingRouteName);

      verify(() => mockCheckAppStartupUseCase.checkAppStartup()).called(1);
      verifyNoMoreInteractions(mockCheckAppStartupUseCase);
    });

    test('returns auth route when status is unauthenticated', () {
      when(
        () => mockCheckAppStartupUseCase.checkAppStartup(),
      ).thenReturn(StartupResult(StartupStatus.unauthenticated, null));

      final route = userCubit.getInitialRoute();
      expect(route, AppRoutes.authScreen);

      verify(() => mockCheckAppStartupUseCase.checkAppStartup()).called(1);
      verifyNoMoreInteractions(mockCheckAppStartupUseCase);
    });

    test(
      'returns master password route and sets currentUser when status is authenticated',
      () {
        when(
          () => mockCheckAppStartupUseCase.checkAppStartup(),
        ).thenReturn(StartupResult(StartupStatus.authenticated, tUser));

        final route = userCubit.getInitialRoute();
        expect(route, AppRoutes.masterPasswordScreen);
        expect(userCubit.currentUser, tUser);

        verify(() => mockCheckAppStartupUseCase.checkAppStartup()).called(1);
        verifyNoMoreInteractions(mockCheckAppStartupUseCase);
      },
    );
  });
}
