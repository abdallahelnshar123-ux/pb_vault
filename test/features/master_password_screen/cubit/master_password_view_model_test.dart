import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/user/my_user.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/use_cases/biometric/biometric_unlock_use_case.dart';
import 'package:pb_vault/domain/use_cases/biometric/enable_biometric_use_case.dart';
import 'package:pb_vault/domain/use_cases/biometric/is_biometric_enabled_use_case.dart';
import 'package:pb_vault/domain/use_cases/biometric/is_biometric_supported_use_case.dart';
import 'package:pb_vault/domain/use_cases/set_master_password_use_case.dart';
import 'package:pb_vault/domain/use_cases/vault/create_vault_verifier_use_case.dart';
import 'package:pb_vault/domain/use_cases/vault/unlock_vault_use_case.dart';
import 'package:pb_vault/features/master_password_screen/cubit/master_password_state.dart';
import 'package:pb_vault/features/master_password_screen/cubit/master_password_view_model.dart';

class MockSetMasterPasswordUseCase extends Mock
    implements SetMasterPasswordUseCase {}

class MockCreateVaultVerifierUseCase extends Mock
    implements CreateVaultVerifierUseCase {}

class MockUnlockVaultUseCase extends Mock implements UnlockVaultUseCase {}

class MockIsBiometricSupportedUseCase extends Mock
    implements IsBiometricSupportedUseCase {}

class MockEnableBiometricUseCase extends Mock
    implements EnableBiometricUseCase {}

class MockIsBiometricEnabledUseCase extends Mock
    implements IsBiometricEnabledUseCase {}

class MockBiometricUnlockUseCase extends Mock
    implements BiometricUnlockUseCase {}

void main() {
  late MasterPasswordCubit cubit;
  late MockSetMasterPasswordUseCase mockSetMasterPasswordUseCase;
  late MockCreateVaultVerifierUseCase mockCreateVaultVerifierUseCase;
  late MockUnlockVaultUseCase mockUnlockVaultUseCase;
  late MockIsBiometricSupportedUseCase mockIsBiometricSupportedUseCase;
  late MockEnableBiometricUseCase mockEnableBiometricUseCase;
  late MockBiometricUnlockUseCase mockBiometricUnlockUseCase;
  late MockIsBiometricEnabledUseCase mockIsBiometricEnabledUseCase;

  const tUser = MyUser(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
    provider: 'google',
  );

  const tSalt = [1, 2, 3];
  const tVerifier = 'verifier_hash';
  const tPassword = 'master_password';

  final tUpdatedUser = tUser.copyWith(passwordVerifier: tVerifier, salt: tSalt);

  setUpAll(() {
    registerFallbackValue(tUser);
  });

  setUp(() {
    mockSetMasterPasswordUseCase = MockSetMasterPasswordUseCase();
    mockCreateVaultVerifierUseCase = MockCreateVaultVerifierUseCase();
    mockUnlockVaultUseCase = MockUnlockVaultUseCase();
    mockIsBiometricSupportedUseCase = MockIsBiometricSupportedUseCase();
    mockEnableBiometricUseCase = MockEnableBiometricUseCase();
    mockIsBiometricEnabledUseCase = MockIsBiometricEnabledUseCase();
    mockBiometricUnlockUseCase = MockBiometricUnlockUseCase();
    cubit = MasterPasswordCubit(
      mockSetMasterPasswordUseCase,
      mockCreateVaultVerifierUseCase,
      mockUnlockVaultUseCase,
      mockIsBiometricSupportedUseCase,
      mockEnableBiometricUseCase,
      mockIsBiometricEnabledUseCase,
      mockBiometricUnlockUseCase,
    );
  });

  group('MasterPasswordCubit', () {
    test('initial state should be MasterPasswordInitial', () {
      expect(cubit.state, isA<MasterPasswordInitial>());
    });

    group('setMasterPassword', () {
      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'emits [MasterPasswordSetupLoading, MasterPasswordSetupSuccess] with isBiometricSupported equals true when successful',
        build: () {
          when(
            () => mockCreateVaultVerifierUseCase.invoke(any()),
          ).thenAnswer((_) async => Right({'hash': tVerifier, 'salt': tSalt}));
          when(
            () => mockSetMasterPasswordUseCase.invoke(user: any(named: 'user')),
          ).thenAnswer((_) async => const Right(unit));
          when(
            () => mockIsBiometricSupportedUseCase.invoke(),
          ).thenAnswer((_) async => const Right(true));
          return cubit;
        },
        act: (cubit) =>
            cubit.setMasterPassword(user: tUser, masterPassword: tPassword),
        expect: () => [
          isA<MasterPasswordSetupLoading>(),
          isA<MasterPasswordSetupSuccess>()
              .having((s) => s.user, 'user', tUpdatedUser)
              .having((s) => s.offerBiometric, "isBiometricEnabled", true),
        ],
        verify: (_) {
          verify(
            () => mockCreateVaultVerifierUseCase.invoke(tPassword),
          ).called(1);
          verify(
            () => mockSetMasterPasswordUseCase.invoke(user: tUpdatedUser),
          ).called(1);
          verify(() => mockIsBiometricSupportedUseCase.invoke()).called(1);
          verifyNoMoreInteractions(mockCreateVaultVerifierUseCase);
          verifyNoMoreInteractions(mockSetMasterPasswordUseCase);
          verifyNoMoreInteractions(mockIsBiometricSupportedUseCase);
        },
      );

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'emits [MasterPasswordSetupLoading, MasterPasswordSetupSuccess] with isBiometricSupported equals false when successful',
        build: () {
          when(
            () => mockCreateVaultVerifierUseCase.invoke(any()),
          ).thenAnswer((_) async => Right({'hash': tVerifier, 'salt': tSalt}));
          when(
            () => mockSetMasterPasswordUseCase.invoke(user: any(named: 'user')),
          ).thenAnswer((_) async => const Right(unit));
          when(
            () => mockIsBiometricSupportedUseCase.invoke(),
          ).thenAnswer((_) async => const Right(false));
          return cubit;
        },
        act: (cubit) =>
            cubit.setMasterPassword(user: tUser, masterPassword: tPassword),
        expect: () => [
          isA<MasterPasswordSetupLoading>(),
          isA<MasterPasswordSetupSuccess>()
              .having((s) => s.user, 'user', tUpdatedUser)
              .having((s) => s.offerBiometric, "isBiometricEnabled", false),
        ],
        verify: (_) {
          verify(
            () => mockCreateVaultVerifierUseCase.invoke(tPassword),
          ).called(1);
          verify(
            () => mockSetMasterPasswordUseCase.invoke(user: tUpdatedUser),
          ).called(1);
          verify(() => mockIsBiometricSupportedUseCase.invoke()).called(1);
          verifyNoMoreInteractions(mockCreateVaultVerifierUseCase);
          verifyNoMoreInteractions(mockSetMasterPasswordUseCase);
          verifyNoMoreInteractions(mockIsBiometricSupportedUseCase);
        },
      );

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'emits [MasterPasswordSetupLoading, MasterPasswordSetupError] when set master password use case fails',
        build: () {
          when(
            () => mockCreateVaultVerifierUseCase.invoke(any()),
          ).thenAnswer((_) async => Right({'hash': tVerifier, 'salt': tSalt}));
          when(
            () => mockSetMasterPasswordUseCase.invoke(user: any(named: 'user')),
          ).thenAnswer((_) async => const Left(ServerFailure('error')));
          return cubit;
        },
        act: (cubit) =>
            cubit.setMasterPassword(user: tUser, masterPassword: tPassword),
        expect: () => [
          isA<MasterPasswordSetupLoading>(),
          isA<MasterPasswordSetupError>().having(
            (s) => s.message,
            'message',
            'error',
          ),
        ],
        verify: (_) {
          verify(
            () => mockCreateVaultVerifierUseCase.invoke(tPassword),
          ).called(1);
          verify(
            () => mockSetMasterPasswordUseCase.invoke(user: any(named: 'user')),
          ).called(1);
          verifyNoMoreInteractions(mockCreateVaultVerifierUseCase);
          verifyNoMoreInteractions(mockSetMasterPasswordUseCase);
        },
      );
    });

    group('verifyMasterPassword', () {
      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'emits [MasterPasswordVerifyLoading, MasterPasswordVerifySuccess]  with offer biometric equal true  when successful and unlock is true ',
        build: () {
          when(
            () => mockUnlockVaultUseCase.invoke(
              password: any(named: 'password'),
              salt: any(named: 'salt'),
              verifier: any(named: 'verifier'),
            ),
          ).thenAnswer((_) async => Right(true));
          when(
            () => mockIsBiometricSupportedUseCase.invoke(),
          ).thenAnswer((_) async => Right(true));
          when(
            () => mockIsBiometricEnabledUseCase.invoke(),
          ).thenReturn(Right(false));
          return cubit;
        },
        act: (cubit) => cubit.verifyMasterPassword(
          salt: tSalt,
          masterPassword: tPassword,
          passwordVerifier: tVerifier,
        ),
        expect: () => [
          isA<MasterPasswordVerifyLoading>(),
          isA<MasterPasswordVerifySuccess>().having(
            (s) => s.offerBiometric,
            "offer biometric",
            true,
          ),
        ],
        verify: (_) {
          verify(
            () => mockUnlockVaultUseCase.invoke(
              password: tPassword,
              salt: tSalt,
              verifier: tVerifier,
            ),
          ).called(1);
          verify(() => mockIsBiometricEnabledUseCase.invoke()).called(1);
          verify(() => mockIsBiometricSupportedUseCase.invoke()).called(1);
          verifyNoMoreInteractions(mockUnlockVaultUseCase);
          verifyNoMoreInteractions(mockIsBiometricSupportedUseCase);
          verifyNoMoreInteractions(mockIsBiometricEnabledUseCase);
        },
      );

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'emits [MasterPasswordVerifyLoading, MasterPasswordVerifySuccess]  with offer biometric equal false  when successful and unlock is true ',
        build: () {
          when(
            () => mockUnlockVaultUseCase.invoke(
              password: any(named: 'password'),
              salt: any(named: 'salt'),
              verifier: any(named: 'verifier'),
            ),
          ).thenAnswer((_) async => Right(true));
          when(
            () => mockIsBiometricSupportedUseCase.invoke(),
          ).thenAnswer((_) async => Right(true));
          when(
            () => mockIsBiometricEnabledUseCase.invoke(),
          ).thenReturn(Right(true));
          return cubit;
        },
        act: (cubit) => cubit.verifyMasterPassword(
          salt: tSalt,
          masterPassword: tPassword,
          passwordVerifier: tVerifier,
        ),
        expect: () => [
          isA<MasterPasswordVerifyLoading>(),
          isA<MasterPasswordVerifySuccess>().having(
            (s) => s.offerBiometric,
            "offer biometric",
            false,
          ),
        ],
        verify: (_) {
          verify(
            () => mockUnlockVaultUseCase.invoke(
              password: tPassword,
              salt: tSalt,
              verifier: tVerifier,
            ),
          ).called(1);
          verify(() => mockIsBiometricEnabledUseCase.invoke()).called(1);
          verify(() => mockIsBiometricSupportedUseCase.invoke()).called(1);
          verifyNoMoreInteractions(mockUnlockVaultUseCase);
          verifyNoMoreInteractions(mockIsBiometricSupportedUseCase);
          verifyNoMoreInteractions(mockIsBiometricEnabledUseCase);
        },
      );

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'emits [MasterPasswordVerifyLoading, MasterPasswordVerifySuccess]  with offer biometric equal false  when successful and unlock is true ',
        build: () {
          when(
            () => mockUnlockVaultUseCase.invoke(
              password: any(named: 'password'),
              salt: any(named: 'salt'),
              verifier: any(named: 'verifier'),
            ),
          ).thenAnswer((_) async => Right(true));
          when(
            () => mockIsBiometricSupportedUseCase.invoke(),
          ).thenAnswer((_) async => Right(false));
          when(
            () => mockIsBiometricEnabledUseCase.invoke(),
          ).thenReturn(Right(false));
          return cubit;
        },
        act: (cubit) => cubit.verifyMasterPassword(
          salt: tSalt,
          masterPassword: tPassword,
          passwordVerifier: tVerifier,
        ),
        expect: () => [
          isA<MasterPasswordVerifyLoading>(),
          isA<MasterPasswordVerifySuccess>().having(
            (s) => s.offerBiometric,
            "offer biometric",
            false,
          ),
        ],
        verify: (_) {
          verify(
            () => mockUnlockVaultUseCase.invoke(
              password: tPassword,
              salt: tSalt,
              verifier: tVerifier,
            ),
          ).called(1);
          verify(() => mockIsBiometricEnabledUseCase.invoke()).called(1);
          verify(() => mockIsBiometricSupportedUseCase.invoke()).called(1);
          verifyNoMoreInteractions(mockUnlockVaultUseCase);
          verifyNoMoreInteractions(mockIsBiometricSupportedUseCase);
          verifyNoMoreInteractions(mockIsBiometricEnabledUseCase);
        },
      );

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'emits [MasterPasswordVerifyLoading, MasterPasswordVerifyError] with specific message when verification fails',
        build: () {
          when(
            () => mockUnlockVaultUseCase.invoke(
              password: any(named: 'password'),
              salt: any(named: 'salt'),
              verifier: any(named: 'verifier'),
            ),
          ).thenAnswer((_) async => Right(false));
          return cubit;
        },
        act: (cubit) => cubit.verifyMasterPassword(
          salt: tSalt,
          masterPassword: tPassword,
          passwordVerifier: tVerifier,
        ),
        expect: () => [
          isA<MasterPasswordVerifyLoading>(),
          isA<MasterPasswordVerifyError>().having(
            (s) => s.message,
            'message',
            'invalid_master_password',
          ),
        ],
        verify: (_) {
          verify(
            () => mockUnlockVaultUseCase.invoke(
              password: tPassword,
              salt: tSalt,
              verifier: tVerifier,
            ),
          ).called(1);
          verifyNoMoreInteractions(mockUnlockVaultUseCase);
          verifyZeroInteractions(mockIsBiometricEnabledUseCase);
          verifyZeroInteractions(mockIsBiometricSupportedUseCase);
        },
      );

      final tFailure = UnexpectedFailure('error');
      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'emits [MasterPasswordVerifyLoading, MasterPasswordVerifyError] with same message from failure when verification fails',
        build: () {
          when(
            () => mockUnlockVaultUseCase.invoke(
              password: any(named: 'password'),
              salt: any(named: 'salt'),
              verifier: any(named: 'verifier'),
            ),
          ).thenAnswer((_) async => Left(tFailure));
          return cubit;
        },
        act: (cubit) => cubit.verifyMasterPassword(
          salt: tSalt,
          masterPassword: tPassword,
          passwordVerifier: tVerifier,
        ),
        expect: () => [
          isA<MasterPasswordVerifyLoading>(),
          isA<MasterPasswordVerifyError>().having(
            (s) => s.message,
            'message',
            'error',
          ),
        ],
        verify: (_) {
          verify(
            () => mockUnlockVaultUseCase.invoke(
              password: tPassword,
              salt: tSalt,
              verifier: tVerifier,
            ),
          ).called(1);
          verifyNoMoreInteractions(mockUnlockVaultUseCase);
          verifyZeroInteractions(mockIsBiometricEnabledUseCase);
          verifyZeroInteractions(mockIsBiometricSupportedUseCase);
        },
      );
    });

    group("biometricUnlock", () {
      test('should emit nothing when biometric is disabled', () {
        when(
          () => mockIsBiometricEnabledUseCase.invoke(),
        ).thenReturn(const Right(false));
        cubit.biometricUnlock();
        verify(() => mockIsBiometricEnabledUseCase.invoke()).called(1);

        verifyNever(() => mockBiometricUnlockUseCase.invoke());
      });

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'should emit loading then success when biometric unlock succeeds',
        build: () {
          when(
            () => mockIsBiometricEnabledUseCase.invoke(),
          ).thenReturn(const Right(true));

          when(
            () => mockBiometricUnlockUseCase.invoke(),
          ).thenAnswer((_) async => const Right(true));

          return cubit;
        },
        act: (cubit) => cubit.biometricUnlock(),
        expect: () => [
          MasterPasswordVerifyLoading(),
          MasterPasswordVerifySuccess(),
        ],
      );

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'should emit loading then initial when biometric authentication returns false',
        build: () {
          when(
            () => mockIsBiometricEnabledUseCase.invoke(),
          ).thenReturn(const Right(true));

          when(
            () => mockBiometricUnlockUseCase.invoke(),
          ).thenAnswer((_) async => const Right(false));

          return cubit;
        },
        act: (cubit) => cubit.biometricUnlock(),
        expect: () => [MasterPasswordVerifyLoading(), MasterPasswordInitial()],
      );

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'should emit loading then error when biometric unlock fails',
        build: () {
          when(
            () => mockIsBiometricEnabledUseCase.invoke(),
          ).thenReturn(const Right(true));

          when(
            () => mockBiometricUnlockUseCase.invoke(),
          ).thenAnswer((_) async => Left(UnexpectedFailure('biometric_error')));

          return cubit;
        },
        act: (cubit) => cubit.biometricUnlock(),
        expect: () => [
          MasterPasswordVerifyLoading(),
          MasterPasswordVerifyError('biometric_error'),
        ],
      );
    });

    group('enableBiometric', () {
      test('should return true when enabling biometric succeeds', () async {
        when(
          () => mockEnableBiometricUseCase.invoke(true),
        ).thenAnswer((_) async => const Right(unit));

        final result = await cubit.enableBiometric(true);

        expect(result, true);
        expect(cubit.state, isA<MasterPasswordInitial>());
      });

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'should emit error state and return false when enable biometric fails',
        build: () {
          when(
            () => mockEnableBiometricUseCase.invoke(true),
          ).thenAnswer((_) async => Left(UnexpectedFailure('enable_failed')));

          return cubit;
        },
        act: (cubit) async {
          final result = await cubit.enableBiometric(true);
          expect(result, false);
        },
        expect: () => [BiometricErrorState('enable_failed')],
      );

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'should return false without emitting when user cancels biometric prompt',
        build: () {
          when(
            () => mockEnableBiometricUseCase.invoke(true),
          ).thenAnswer((_) async => Left(CancelledByUserFailure()));

          return cubit;
        },
        act: (cubit) async {
          final result = await cubit.enableBiometric(true);
          expect(result, false);
        },
        expect: () => <MasterPasswordState>[],
      );
    });

    group('lockVault', () {
      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'should emit initial state when lockVault is called',
        build: () => cubit,
        seed: () => MasterPasswordVerifySuccess(),
        act: (cubit) => cubit.lockVault(),
        expect: () => [MasterPasswordInitial()],
      );
    });
  });
}
