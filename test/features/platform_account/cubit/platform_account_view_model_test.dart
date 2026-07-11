import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_data.dart';
import 'package:pb_vault/domain/entities/vault/encrypted_data.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/use_cases/add_account_use_case.dart';
import 'package:pb_vault/domain/use_cases/delete_account_from_vault_use_case.dart';
import 'package:pb_vault/domain/use_cases/update_account_use_case.dart';
import 'package:pb_vault/domain/use_cases/vault/encrypt_password_use_case.dart';
import 'package:pb_vault/features/platform_account/cubit/platform_account_state.dart';
import 'package:pb_vault/features/platform_account/cubit/platform_account_view_model.dart';

class MockAddPlatformAccountUseCase extends Mock
    implements AddPlatformAccountUseCase {}

class MockEncryptPasswordUseCase extends Mock
    implements EncryptPasswordUseCase {}

class MockUpdatePlatformAccountUseCase extends Mock
    implements UpdatePlatformAccountUseCase {}

class MockDeletePlatformAccountUseCase extends Mock
    implements DeletePlatformAccountUseCase {}

class FakePlatformAccount extends Fake implements PlatformAccount {}

void main() {
  late PlatformAccountCubit cubit;
  late MockAddPlatformAccountUseCase mockAddAccount;
  late MockEncryptPasswordUseCase mockEncrypt;
  late MockUpdatePlatformAccountUseCase mockUpdateAccount;
  late MockDeletePlatformAccountUseCase mockDeleteAccount;

  setUpAll(() {
    registerFallbackValue(FakePlatformAccount());
  });

  setUp(() {
    mockAddAccount = MockAddPlatformAccountUseCase();
    mockEncrypt = MockEncryptPasswordUseCase();
    mockUpdateAccount = MockUpdatePlatformAccountUseCase();
    mockDeleteAccount = MockDeletePlatformAccountUseCase();

    // Correct order: update, delete, add, encrypt
    cubit = PlatformAccountCubit(
      mockUpdateAccount,
      mockDeleteAccount,
      mockAddAccount,
      mockEncrypt,
    );
  });

  const tUserId = 'user_id';
  const tPlatformData = PlatformData(
    name: 'Google',
    icon: 'icon',
    website: 'google.com',
  );
  final tAccount = PlatformAccount(
    id: '1',
    platform: tPlatformData,
    emailOrUsername: 'test@gmail.com',
    encryptedPassword: const [1, 2, 3],
    createdAt: DateTime(2023),
    mac: const [4, 5, 6],
    nonce: const [7, 8, 9],
  );

  group('generateStrongPassword', () {
    test('should generate a password of length 16', () {
      final password = cubit.generateStrongPassword();

      expect(password.length, 16);
    });

    test('should generate a password using only allowed characters', () {
      final password = cubit.generateStrongPassword();

      expect(
        RegExp(r'^[a-zA-Z0-9@#%^&*_\-+()\[\]{}]{16}$').hasMatch(password),
        isTrue,
      );
    });

    test('should generate different passwords', () {
      final password1 = cubit.generateStrongPassword();
      final password2 = cubit.generateStrongPassword();

      expect(password1, isNot(password2));
    });
  });

  group('addPlatformAccount', () {
    final tEncryptedData = EncryptedData(
      cipherText: [1, 2, 3],
      mac: [4, 5, 6],
      nonce: [7, 8, 9],
    );

    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'emits [AddPlatformAccountLoadingState, AddPlatformAccountSuccessState] when success',
      build: () {
        when(
          () => mockEncrypt.invoke(any()),
        ).thenAnswer((_) async => tEncryptedData);
        when(
          () => mockAddAccount.invoke(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) => cubit.addPlatformAccount(
        userId: tUserId,
        platform: tPlatformData,
        emailOrUsername: 'test@gmail.com',
        password: 'password',
      ),
      expect: () => [
        isA<AddPlatformAccountLoadingState>(),
        isA<AddPlatformAccountSuccessState>(),
      ],
      verify: (_) {
        verify(() => mockEncrypt.invoke('password')).called(1);
        verify(() {
          mockAddAccount.invoke(
            tUserId,
            any(
              that: isA<PlatformAccount>()
                  .having((e) => e.emailOrUsername, 'email', 'test@gmail.com')
                  .having((e) => e.platform, 'platform', tPlatformData),
            ),
          );
        }).called(1);
      },
    );

    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'emits [AddPlatformAccountLoadingState, AddPlatformAccountErrorState] when encryption fails',
      build: () {
        when(() => mockEncrypt.invoke(any())).thenThrow(Exception('Error'));
        return cubit;
      },
      act: (cubit) => cubit.addPlatformAccount(
        userId: tUserId,
        platform: tPlatformData,
        emailOrUsername: 'test@gmail.com',
        password: 'password',
      ),
      expect: () => [
        isA<AddPlatformAccountLoadingState>(),
        isA<AddPlatformAccountErrorState>().having(
          (s) => s.message,
          'message',
          'Exception: Error',
        ),
      ],
    );

    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'emits [AddPlatformAccountLoadingState, AddPlatformAccountErrorState] when add fails',
      build: () {
        when(
          () => mockEncrypt.invoke(any()),
        ).thenAnswer((_) async => tEncryptedData);
        when(
          () => mockAddAccount.invoke(any(), any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return cubit;
      },
      act: (cubit) => cubit.addPlatformAccount(
        userId: tUserId,
        platform: tPlatformData,
        emailOrUsername: 'test@gmail.com',
        password: 'password',
      ),
      expect: () => [
        isA<AddPlatformAccountLoadingState>(),
        isA<AddPlatformAccountErrorState>().having(
          (s) => s.message,
          'message',
          'Server Error',
        ),
      ],
    );
  });

  group('updatePlatformAccount', () {
    final tEncryptedData = EncryptedData(
      cipherText: [1, 2, 3],
      mac: [4, 5, 6],
      nonce: [7, 8, 9],
    );

    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'emits [EditPlatformAccountLoadingState, EditPlatformAccountSuccessState] when success',
      build: () {
        when(
          () => mockEncrypt.invoke(any()),
        ).thenAnswer((_) async => tEncryptedData);
        when(
          () => mockUpdateAccount.invoke(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) => cubit.updatePlatformAccount(
        userId: tUserId,
        originalAccount: tAccount,
        emailOrUsername: 'new@gmail.com',
        password: 'new_password',
      ),
      expect: () => [
        isA<EditPlatformAccountLoadingState>(),
        isA<EditPlatformAccountSuccessState>(),
      ],
      verify: (_) {
        verify(() => mockEncrypt.invoke('new_password')).called(1);
        verify(() => mockUpdateAccount.invoke(tUserId, any())).called(1);
        // ابقي اعمل هنا تست اكتر صرامه زي addAccount
      },
    );

    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'emits [EditPlatformAccountLoadingState, EditPlatformAccountErrorState] when update fails',
      build: () {
        when(
          () => mockEncrypt.invoke(any()),
        ).thenAnswer((_) async => tEncryptedData);
        when(
          () => mockUpdateAccount.invoke(any(), any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Update Error')));
        return cubit;
      },
      act: (cubit) => cubit.updatePlatformAccount(
        userId: tUserId,
        originalAccount: tAccount,
        emailOrUsername: 'new@gmail.com',
        password: 'new_password',
      ),
      expect: () => [
        isA<EditPlatformAccountLoadingState>(),
        isA<EditPlatformAccountErrorState>().having(
          (s) => s.message,
          'message',
          'Update Error',
        ),
      ],
    );

    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'emits [EditPlatformAccountLoadingState, EditPlatformAccountErrorState] when encryption fails',
      build: () {
        when(() => mockEncrypt.invoke(any())).thenThrow(Exception('Error'));
        return cubit;
      },
      act: (cubit) => cubit.updatePlatformAccount(
        userId: tUserId,
        originalAccount: tAccount,
        emailOrUsername: 'new@gmail.com',
        password: 'new_password',
      ),
      expect: () => [
        isA<EditPlatformAccountLoadingState>(),
        isA<EditPlatformAccountErrorState>().having(
          (e) => e.message,
          'message',
          'Exception: Error',
        ),
      ],
    );
  });

  group('deletePlatformAccount', () {
    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'emits [DeletePlatformAccountLoadingState, DeletePlatformAccountSuccessState] when success',
      build: () {
        when(
          () => mockDeleteAccount.invoke(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) =>
          cubit.deletePlatformAccount(userId: tUserId, accountId: '1'),
      expect: () => [
        isA<DeletePlatformAccountLoadingState>(),
        isA<DeletePlatformAccountSuccessState>(),
      ],
      verify: (_) {
        verify(() => mockDeleteAccount.invoke(tUserId, '1')).called(1);
      },
    );

    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'emits [DeletePlatformAccountLoadingState, DeletePlatformAccountErrorState] when failure',
      build: () {
        when(
          () => mockDeleteAccount.invoke(any(), any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Delete Error')));
        return cubit;
      },
      act: (cubit) =>
          cubit.deletePlatformAccount(userId: tUserId, accountId: '1'),
      expect: () => [
        isA<DeletePlatformAccountLoadingState>(),
        isA<DeletePlatformAccountErrorState>().having(
          (s) => s.message,
          'message',
          'Delete Error',
        ),
      ],
    );
  });

  group('searchPlatformAccounts', () {
    final tAccount1 = PlatformAccount(
      id: '1',
      platform: const PlatformData(name: 'Google', icon: 'i', website: 'w'),
      emailOrUsername: 'user1',
      encryptedPassword: const [],
      createdAt: DateTime(2023),
      mac: const [],
      nonce: const [],
    );
    final tAccount2 = PlatformAccount(
      id: '2',
      platform: const PlatformData(name: 'Facebook', icon: 'i', website: 'w'),
      emailOrUsername: 'user2',
      encryptedPassword: const [],
      createdAt: DateTime(2023),
      mac: const [],
      nonce: const [],
    );
    final allAccounts = [tAccount1, tAccount2];

    test('should return all accounts when query is empty', () {
      final result = cubit.searchPlatformAccounts(
        accountsList: allAccounts,
        searchTerm: '',
      );
      expect(result, allAccounts);
    });

    test('should filter by emailOrUsername (case-insensitive)', () {
      final result = cubit.searchPlatformAccounts(
        accountsList: allAccounts,
        searchTerm: 'USER1',
      );
      expect(result, [tAccount1]);
    });

    test('should filter by platform name (case-insensitive)', () {
      final result = cubit.searchPlatformAccounts(
        accountsList: allAccounts,
        searchTerm: 'face',
      );
      expect(result, [tAccount2]);
    });

    test('should trim query', () {
      final result = cubit.searchPlatformAccounts(
        accountsList: allAccounts,
        searchTerm: '  user2  ',
      );
      expect(result, [tAccount2]);
    });

    test('should return empty list if no match', () {
      final result = cubit.searchPlatformAccounts(
        accountsList: allAccounts,
        searchTerm: 'none',
      );
      expect(result, isEmpty);
    });
  });
}
