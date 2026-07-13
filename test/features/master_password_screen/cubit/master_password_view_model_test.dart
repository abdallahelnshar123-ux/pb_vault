import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/user/my_user.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/use_cases/biometric/enable_biometric_use_case.dart';
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

void main() {
  late MasterPasswordCubit cubit;
  late MockSetMasterPasswordUseCase mockSetMasterPasswordUseCase;
  late MockCreateVaultVerifierUseCase mockCreateVaultVerifierUseCase;
  late MockUnlockVaultUseCase mockUnlockVaultUseCase;
  late MockIsBiometricSupportedUseCase mockIsBiometricSupportedUseCase;
  late MockEnableBiometricUseCase mockEnableBiometricUseCase;

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
    cubit = MasterPasswordCubit(
      mockSetMasterPasswordUseCase,
      mockCreateVaultVerifierUseCase,
      mockUnlockVaultUseCase,
      mockIsBiometricSupportedUseCase,
      mockEnableBiometricUseCase,
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
        'emits [MasterPasswordVerifyLoading, MasterPasswordVerifySuccess] when successful',
        build: () {
          when(
            () => mockUnlockVaultUseCase.invoke(
              password: any(named: 'password'),
              salt: any(named: 'salt'),
              verifier: any(named: 'verifier'),
            ),
          ).thenAnswer((_) async => Right(true));
          return cubit;
        },
        act: (cubit) => cubit.verifyMasterPassword(
          salt: tSalt,
          masterPassword: tPassword,
          passwordVerifier: tVerifier,
        ),
        expect: () => [
          isA<MasterPasswordVerifyLoading>(),
          isA<MasterPasswordVerifySuccess>(),
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
        },
      );

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'emits [MasterPasswordVerifyLoading, MasterPasswordVerifyError] when verification fails',
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
          isA<MasterPasswordVerifyError>(),
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
        },
      );
    });

    group('enableBiometric', () {
      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'emits [BiometricLoading, BiometricSuccess] when enableBiometricUseCase succeeds',
        build: () {
          when(
            () => mockEnableBiometricUseCase.invoke(any()),
          ).thenAnswer((_) async => const Right(unit));
          return cubit;
        },
        act: (cubit) => cubit.enableBiometric(true),
        expect: () => [],
        verify: (_) {
          verify(() => mockEnableBiometricUseCase.invoke(true)).called(1);
          verifyNoMoreInteractions(mockEnableBiometricUseCase);
        },
      );

      blocTest<MasterPasswordCubit, MasterPasswordState>(
        'emits [BiometricLoading, BiometricError] when enableBiometricUseCase fails',
        build: () {
          when(() => mockEnableBiometricUseCase.invoke(any())).thenAnswer(
            (_) async => const Left(ServerFailure('biometric error')),
          );
          return cubit;
        },
        act: (cubit) => cubit.enableBiometric(true),
        expect: () => [
          isA<BiometricErrorState>().having(
            (s) => s.message,
            'message',
            'biometric error',
          ),
        ],
        verify: (_) {
          verify(() => mockEnableBiometricUseCase.invoke(true)).called(1);
          verifyNoMoreInteractions(mockEnableBiometricUseCase);
        },
      );
    });
  });
}
