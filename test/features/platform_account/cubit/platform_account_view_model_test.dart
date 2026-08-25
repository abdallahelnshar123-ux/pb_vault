import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_data.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/use_cases/add_account_use_case.dart';
import 'package:pb_vault/domain/use_cases/delete_account_from_vault_use_case.dart';
import 'package:pb_vault/domain/use_cases/get_account_by_id_use_case.dart';
import 'package:pb_vault/domain/use_cases/update_account_use_case.dart';
import 'package:pb_vault/features/platform_account/cubit/platform_account_state.dart';
import 'package:pb_vault/features/platform_account/cubit/platform_account_view_model.dart';

class MockAddPlatformAccountUseCase extends Mock
    implements AddPlatformAccountUseCase {}

class MockUpdatePlatformAccountUseCase extends Mock
    implements UpdatePlatformAccountUseCase {}

class MockDeletePlatformAccountUseCase extends Mock
    implements DeletePlatformAccountUseCase {}

class MockGetAccountByIdUseCase extends Mock implements GetAccountByIdUseCase {}

class FakePlatformAccount extends Fake implements PlatformAccount {}

void main() {
  late PlatformAccountCubit cubit;
  late MockAddPlatformAccountUseCase mockAddAccount;
  late MockUpdatePlatformAccountUseCase mockUpdateAccount;
  late MockDeletePlatformAccountUseCase mockDeleteAccount;
  late MockGetAccountByIdUseCase mockGetAccountById;

  setUpAll(() {
    registerFallbackValue(FakePlatformAccount());
  });

  setUp(() {
    mockAddAccount = MockAddPlatformAccountUseCase();
    mockUpdateAccount = MockUpdatePlatformAccountUseCase();
    mockDeleteAccount = MockDeletePlatformAccountUseCase();
    mockGetAccountById = MockGetAccountByIdUseCase();

    cubit = PlatformAccountCubit(
      mockUpdateAccount,
      mockDeleteAccount,
      mockAddAccount,
      mockGetAccountById,
    );
  });

  const tUserId = 'user_id';
  const tPlatformData = PlatformData(
    id: 'google_id',
    name: 'Google',
    iconPath: 'icon',
    website: 'google.com',
  );
  final tAccount = PlatformAccount(
    id: '1',
    platformId: tPlatformData.id,
    identifier: 'test@gmail.com',
    password: 'testPassword',
    createdAt: DateTime(2023),
  );

  group('addPlatformAccount', () {
    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'should emit [AddPlatformAccountLoadingState, AddPlatformAccountSuccessState] when success',
      build: () {
        when(
          () => mockAddAccount.invoke(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) => cubit.addPlatformAccount(
        userId: tUserId,
        platform: tPlatformData,
        identifier: 'test@gmail.com',
        password: 'password',
      ),
      expect: () => [
        isA<AddPlatformAccountLoadingState>(),
        isA<AddPlatformAccountSuccessState>(),
      ],
      verify: (_) {
        verify(() => mockAddAccount.invoke(
              tUserId,
              any(
                that: isA<PlatformAccount>()
                    .having((e) => e.identifier, 'identifier', 'test@gmail.com')
                    .having((e) => e.platformId, 'platformId', tPlatformData.id)
                    .having((e) => e.password, 'password', 'password'),
              ),
            )).called(1);
        verifyNoMoreInteractions(mockAddAccount);
        verifyZeroInteractions(mockUpdateAccount);
        verifyZeroInteractions(mockDeleteAccount);
        verifyZeroInteractions(mockGetAccountById);
      },
    );

    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'should emit [AddPlatformAccountLoadingState, AddPlatformAccountErrorState] when add fails',
      build: () {
        when(
          () => mockAddAccount.invoke(any(), any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return cubit;
      },
      act: (cubit) => cubit.addPlatformAccount(
        userId: tUserId,
        platform: tPlatformData,
        identifier: 'test@gmail.com',
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
      verify: (_) {
        verify(() => mockAddAccount.invoke(any(), any())).called(1);
        verifyNoMoreInteractions(mockAddAccount);
      },
    );
  });

  group('getAccountById', () {
    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'should emit [GetPlatformAccountLoadingState, GetPlatformAccountSuccessState] when success',
      build: () {
        when(() => mockGetAccountById.invoke(
              userId: any(named: 'userId'),
              accountId: any(named: 'accountId'),
            )).thenAnswer((_) async => Right(tAccount));
        return cubit;
      },
      act: (cubit) => cubit.getAccountById(userId: tUserId, accountId: '1'),
      expect: () => [
        isA<GetPlatformAccountLoadingState>(),
        isA<GetPlatformAccountSuccessState>().having(
          (s) => s.account,
          'account',
          tAccount,
        ),
      ],
      verify: (_) {
        verify(() => mockGetAccountById.invoke(
              userId: tUserId,
              accountId: '1',
            )).called(1);
        verifyNoMoreInteractions(mockGetAccountById);
      },
    );

    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'should emit [GetPlatformAccountLoadingState, GetPlatformAccountErrorState] when failure',
      build: () {
        when(() => mockGetAccountById.invoke(
              userId: any(named: 'userId'),
              accountId: any(named: 'accountId'),
            )).thenAnswer((_) async => const Left(ServerFailure('Error')));
        return cubit;
      },
      act: (cubit) => cubit.getAccountById(userId: tUserId, accountId: '1'),
      expect: () => [
        isA<GetPlatformAccountLoadingState>(),
        isA<GetPlatformAccountErrorState>().having(
          (s) => s.message,
          'message',
          'Error',
        ),
      ],
      verify: (_) {
        verify(() => mockGetAccountById.invoke(userId: any(named: 'userId'),
          accountId: any(named: 'accountId'),)).called(1);
        verifyNoMoreInteractions(mockGetAccountById);
      },
    );
  });

  group('updatePlatformAccount', () {
    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'should emit [EditPlatformAccountLoadingState, EditPlatformAccountSuccessState] when success',
      build: () {
        when(
          () => mockUpdateAccount.invoke(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) => cubit.updatePlatformAccount(
        userId: tUserId,
        accountId: '1',
        platform: tPlatformData,
        identifier: 'new@gmail.com',
        password: 'new_password',
      ),
      expect: () => [
        isA<EditPlatformAccountLoadingState>(),
        isA<EditPlatformAccountSuccessState>(),
      ],
      verify: (_) {
        verify(() => mockUpdateAccount.invoke(
              tUserId,
              any(
                that: isA<PlatformAccount>()
                    .having((e) => e.id, 'id', '1')
                    .having((e) => e.platformId, 'platformId', tPlatformData.id)
                    .having((e) => e.identifier, 'identifier', 'new@gmail.com')
                    .having((e) => e.password, 'password', 'new_password'),
              ),
            )).called(1);
        verifyNoMoreInteractions(mockUpdateAccount);
      },
    );

    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'should emit [EditPlatformAccountLoadingState, EditPlatformAccountErrorState] when update fails',
      build: () {
        when(
          () => mockUpdateAccount.invoke(any(), any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Update Error')));
        return cubit;
      },
      act: (cubit) => cubit.updatePlatformAccount(
        userId: tUserId,
        accountId: '1',
        platform: tPlatformData,
        identifier: 'new@gmail.com',
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
      verify: (_) {
        verify(() => mockUpdateAccount.invoke(any(), any())).called(1);
        verifyNoMoreInteractions(mockUpdateAccount);
      },
    );
  });

  group('deletePlatformAccount', () {
    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'should emit [DeletePlatformAccountLoadingState, DeletePlatformAccountSuccessState] when success',
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
        verifyNoMoreInteractions(mockDeleteAccount);
      },
    );

    blocTest<PlatformAccountCubit, PlatformAccountState>(
      'should emit [DeletePlatformAccountLoadingState, DeletePlatformAccountErrorState] when failure',
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
      verify: (_) {
        verify(() => mockDeleteAccount.invoke(any(), any())).called(1);
        verifyNoMoreInteractions(mockDeleteAccount);
      },
    );
  });

  group('searchPlatformAccounts', () {
    const tPlatformGoogle = PlatformData(
      id: 'google_id',
      name: 'Google',
      iconPath: 'i',
      website: 'w',
    );
    const tPlatformFacebook = PlatformData(
      id: 'facebook_id',
      name: 'Facebook',
      iconPath: 'i',
      website: 'w',
    );

    final platformsMap = {
      tPlatformGoogle.id: tPlatformGoogle,
      tPlatformFacebook.id: tPlatformFacebook,
    };

    final tAccount1 = PlatformAccount(
      id: '1',
      platformId: tPlatformGoogle.id,
      identifier: 'user1',
      createdAt: DateTime(2023),
    );
    final tAccount2 = PlatformAccount(
      id: '2',
      platformId: tPlatformFacebook.id,
      identifier: 'user2',
      createdAt: DateTime(2023),
    );
    final allAccounts = [tAccount1, tAccount2];

    test('should return all accounts when query is empty', () {
      final result = cubit.searchPlatformAccounts(
        platforms: platformsMap,
        accountsList: allAccounts,
        searchTerm: '',
      );
      expect(result, allAccounts);
    });

    test('should filter by identifier (case-insensitive)', () {
      final result = cubit.searchPlatformAccounts(
        platforms: platformsMap,
        accountsList: allAccounts,
        searchTerm: 'USER1',
      );
      expect(result, [tAccount1]);
    });

    test('should filter by platform name (case-insensitive)', () {
      final result = cubit.searchPlatformAccounts(
        platforms: platformsMap,
        accountsList: allAccounts,
        searchTerm: 'face',
      );
      expect(result, [tAccount2]);
    });

    test('should trim query', () {
      final result = cubit.searchPlatformAccounts(
        platforms: platformsMap,
        accountsList: allAccounts,
        searchTerm: '  user2  ',
      );
      expect(result, [tAccount2]);
    });

    test('should return empty list if no match', () {
      final result = cubit.searchPlatformAccounts(
        platforms: platformsMap,
        accountsList: allAccounts,
        searchTerm: 'none',
      );
      expect(result, isEmpty);
    });
  });
}
