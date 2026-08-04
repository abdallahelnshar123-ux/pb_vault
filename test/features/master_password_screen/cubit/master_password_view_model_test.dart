import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/user/my_user.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/use_cases/biometric/biometric_unlock_use_case.dart';
import 'package:pb_vault/domain/use_cases/biometric/enable_biometric_use_case.dart';
import 'package:pb_vault/domain/use_cases/biometric/is_biometric_enabled_use_case.dart';
import 'package:pb_vault/domain/use_cases/biometric/is_biometric_rejected_use_case.dart';
import 'package:pb_vault/domain/use_cases/biometric/is_biometric_supported_use_case.dart';
import 'package:pb_vault/domain/use_cases/biometric/set_biometric_rejected_use_case.dart';
import 'package:pb_vault/domain/use_cases/set_master_password_use_case.dart';
import 'package:pb_vault/domain/use_cases/vault/change_master_password_use_case.dart';
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

class MockIsBiometricRejectedUseCase extends Mock
    implements IsBiometricRejectedUseCase {}

class MockBiometricUnlockUseCase extends Mock
    implements BiometricUnlockUseCase {}

class MockSetBiometricRejectedUseCase extends Mock
    implements SetBiometricRejectedUseCase {}

class MockChangeMasterPasswordUseCase extends Mock
    implements ChangeMasterPasswordUseCase {}

void main() {
  late MasterPasswordCubit cubit;
  late MockSetMasterPasswordUseCase mockSetMasterPasswordUseCase;
  late MockCreateVaultVerifierUseCase mockCreateVaultVerifierUseCase;
  late MockUnlockVaultUseCase mockUnlockVaultUseCase;
  late MockIsBiometricSupportedUseCase mockIsBiometricSupportedUseCase;
  late MockEnableBiometricUseCase mockEnableBiometricUseCase;
  late MockBiometricUnlockUseCase mockBiometricUnlockUseCase;
  late MockIsBiometricEnabledUseCase mockIsBiometricEnabledUseCase;
  late MockIsBiometricRejectedUseCase mockIsBiometricRejectedUseCase;
  late MockSetBiometricRejectedUseCase mockSetBiometricRejectedUseCase;
  late MockChangeMasterPasswordUseCase mockChangeMasterPasswordUseCase;

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
    mockIsBiometricRejectedUseCase = MockIsBiometricRejectedUseCase();
    mockSetBiometricRejectedUseCase = MockSetBiometricRejectedUseCase();
    mockChangeMasterPasswordUseCase = MockChangeMasterPasswordUseCase();

    cubit = MasterPasswordCubit(
      mockSetMasterPasswordUseCase,
      mockCreateVaultVerifierUseCase,
      mockUnlockVaultUseCase,
      mockIsBiometricSupportedUseCase,
      mockEnableBiometricUseCase,
      mockIsBiometricEnabledUseCase,
      mockIsBiometricRejectedUseCase,
      mockBiometricUnlockUseCase,
      mockSetBiometricRejectedUseCase,
      mockChangeMasterPasswordUseCase,
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
      );
    });

    group('unlockVault', () {
      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'emits [UnlockLoadingState, UnlockSuccessState] when successful',
        build: () {
          when(
            () => mockUnlockVaultUseCase.invoke(
              password: any(named: 'password'),
              salt: any(named: 'salt'),
              verifier: any(named: 'verifier'),
            ),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockIsBiometricRejectedUseCase.invoke(),
          ).thenReturn(const Right(false));
          when(
            () => mockIsBiometricSupportedUseCase.invoke(),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockIsBiometricEnabledUseCase.invoke(),
          ).thenReturn(const Right(false));
          return cubit;
        },
        act: (cubit) => cubit.unlockVault(
          salt: tSalt,
          masterPassword: tPassword,
          passwordVerifier: tVerifier,
        ),
        expect: () => [
          isA<UnlockLoadingState>(),
          isA<UnlockSuccessState>().having(
            (s) => s.offerBiometric,
            'offerBiometric',
            true,
          ),
        ],
      );

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'emits [UnlockLoadingState, UnlockErrorState] when verification fails',
        build: () {
          when(
            () => mockUnlockVaultUseCase.invoke(
              password: any(named: 'password'),
              salt: any(named: 'salt'),
              verifier: any(named: 'verifier'),
            ),
          ).thenAnswer((_) async => const Right(false));
          return cubit;
        },
        act: (cubit) => cubit.unlockVault(
          salt: tSalt,
          masterPassword: tPassword,
          passwordVerifier: tVerifier,
        ),
        expect: () => [
          isA<UnlockLoadingState>(),
          isA<UnlockErrorState>().having(
            (s) => s.message,
            'message',
            'invalid_master_password',
          ),
        ],
      );
    });

    group("biometricUnlock", () {
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
        expect: () => [isA<UnlockLoadingState>(), isA<UnlockSuccessState>()],
      );
    });

    group('changeMasterPassword', () {
      const tNewPassword = 'newPassword123';

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'should emit [ChangeMasterPasswordLoading, ChangeMasterPasswordSuccess] when success',
        build: () {
          when(
            () => mockChangeMasterPasswordUseCase.invoke(
              newPassword: any(named: 'newPassword'),
            ),
          ).thenAnswer((_) async => const Right(tUser));
          return cubit;
        },
        act: (cubit) => cubit.changeMasterPassword(tNewPassword),
        expect: () => [
          isA<ChangeMasterPasswordLoading>(),
          isA<ChangeMasterPasswordSuccess>().having(
            (s) => s.user,
            'user',
            tUser,
          ),
        ],
        verify: (_) {
          verify(
            () => mockChangeMasterPasswordUseCase.invoke(
              newPassword: tNewPassword,
            ),
          ).called(1);
          verifyNoMoreInteractions(mockChangeMasterPasswordUseCase);
        },
      );

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'should emit [ChangeMasterPasswordLoading, ChangeMasterPasswordError] when failure',
        build: () {
          when(
            () => mockChangeMasterPasswordUseCase.invoke(
              newPassword: any(named: 'newPassword'),
            ),
          ).thenAnswer((_) async => const Left(ServerFailure('change_failed')));
          return cubit;
        },
        act: (cubit) => cubit.changeMasterPassword(tNewPassword),
        expect: () => [
          isA<ChangeMasterPasswordLoading>(),
          isA<ChangeMasterPasswordError>().having(
            (s) => s.message,
            'message',
            'change_failed',
          ),
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
      });
    });

    group('lockVault', () {
      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'should emit initial state when lockVault is called',
        build: () => cubit,
        seed: () => UnlockSuccessState(),
        act: (cubit) => cubit.lockVault(),
        expect: () => [MasterPasswordInitial()],
      );
    });
  });
}
