import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/use_cases/get_accounts_use_case.dart';
import 'package:pb_vault/features/home_screen/cubit/home_state.dart';
import 'package:pb_vault/features/home_screen/cubit/home_view_model.dart';

class MockGetAccountsUseCase extends Mock implements GetAccountsUseCase {}

void main() {
  late HomeCubit homeCubit;
  late MockGetAccountsUseCase mockGetAccountsUseCase;

  const tUserId = 'user123';

  final tAccount1 = PlatformAccount(
    id: '1',
    platformId: 'facebook_id',
    identifier: 'test@example.com',
    password: 'testPassword',
    createdAt: DateTime(2023, 1, 1),
  );
  final tAccount2 = PlatformAccount(
    id: '2',
    platformId: 'google_id',
    identifier: 'test2@example.com',
    password: 'testPassword2',
    createdAt: DateTime(2023, 1, 1),
  );
  const tFailure = ServerFailure('error_message');

  setUp(() {
    mockGetAccountsUseCase = MockGetAccountsUseCase();
    homeCubit = HomeCubit(mockGetAccountsUseCase);
  });

  tearDown(() {
    homeCubit.close();
  });

  test('should have HomeInitial as initial state', () {
    expect(homeCubit.state, isA<HomeInitial>());
  });

  group('getAccounts', () {
    blocTest<HomeCubit, HomeState>(
      'should emit [HomeLoading, HomeSuccess] when successful',
      build: () {
        when(
          () => mockGetAccountsUseCase.invoke(tUserId),
        ).thenAnswer((_) => Stream.value(Right([tAccount1, tAccount2])));
        return homeCubit;
      },
      act: (cubit) => cubit.getAccounts(tUserId),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeSuccess>().having((s) => s.accounts, 'accounts', [
          tAccount1,
          tAccount2,
        ]),
      ],
      verify: (_) {
        expect(homeCubit.accountsList, [tAccount1, tAccount2]);
        verify(() => mockGetAccountsUseCase.invoke(tUserId)).called(1);
        verifyNoMoreInteractions(mockGetAccountsUseCase);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'should emit [HomeLoading, HomeError] when failure happens',
      build: () {
        when(
          () => mockGetAccountsUseCase.invoke(tUserId),
        ).thenAnswer((_) => Stream.value(const Left(tFailure)));
        return homeCubit;
      },
      act: (cubit) => cubit.getAccounts(tUserId),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeError>().having((s) => s.message, 'message', 'error_message'),
      ],
      verify: (_) {
        verify(() => mockGetAccountsUseCase.invoke(tUserId)).called(1);
        verifyNoMoreInteractions(mockGetAccountsUseCase);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'should emit [HomeLoading] and ignore error if message contains permission-denied',
      build: () {
        when(
          () => mockGetAccountsUseCase.invoke(tUserId),
        ).thenAnswer((_) => Stream.error('permission-denied error'));
        return homeCubit;
      },
      act: (cubit) => cubit.getAccounts(tUserId),
      expect: () => [isA<HomeLoading>()],
      verify: (_) {
        verify(() => mockGetAccountsUseCase.invoke(tUserId)).called(1);
        verifyNoMoreInteractions(mockGetAccountsUseCase);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'should emit [HomeLoading, HomeError] when stream throws non permission error',
      build: () {
        when(
          () => mockGetAccountsUseCase.invoke(tUserId),
        ).thenAnswer((_) => Stream.error('network error'));

        return homeCubit;
      },
      act: (cubit) => cubit.getAccounts(tUserId),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeError>().having((e) => e.message, 'message', 'network error'),
      ],
      verify: (_) {
        verify(() => mockGetAccountsUseCase.invoke(tUserId)).called(1);
        verifyNoMoreInteractions(mockGetAccountsUseCase);
      },
    );

    test(
      'should cancel previous subscription before creating a new one',
      () async {
        // Arrange
        final controller1 =
            StreamController<Either<Failure, List<PlatformAccount>>>();
        final controller2 =
            StreamController<Either<Failure, List<PlatformAccount>>>();

        when(
          () => mockGetAccountsUseCase.invoke(tUserId),
        ).thenAnswer((_) => controller1.stream);

        homeCubit.getAccounts(tUserId);

        when(
          () => mockGetAccountsUseCase.invoke(tUserId),
        ).thenAnswer((_) => controller2.stream);

        homeCubit.getAccounts(tUserId);

        expect(controller1.hasListener, isFalse);
        expect(controller2.hasListener, isTrue);

        await controller1.close();
        await controller2.close();
      },
    );
  });

  group('clearHomeAccounts', () {
    blocTest<HomeCubit, HomeState>(
      'should clear accounts list and emit HomeInitial',
      build: () {
        homeCubit.accountsList = [tAccount1, tAccount2];
        return homeCubit;
      },
      act: (cubit) => cubit.clearHomeAccounts(),
      expect: () => [isA<HomeInitial>()],
      verify: (cubit) {
        expect(cubit.accountsList, isEmpty);
      },
    );
  });
}
