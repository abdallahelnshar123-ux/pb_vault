import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_data.dart';
import 'package:pb_vault/domain/entities/response/platform_account/encrypted_data.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/use_cases/get_accounts_use_case.dart';
import 'package:pb_vault/domain/use_cases/vault/decrypt_password_use_case.dart';
import 'package:pb_vault/features/home_screen/cubit/home_state.dart';
import 'package:pb_vault/features/home_screen/cubit/home_view_model.dart';

class MockGetAccountsUseCase extends Mock implements GetAccountsUseCase {}

class MockDecryptPasswordUseCase extends Mock
    implements DecryptPasswordUseCase {}

class FakeEncryptedData extends Fake implements EncryptedData {}

void main() {
  late HomeCubit homeCubit;
  late MockGetAccountsUseCase mockGetAccountsUseCase;
  late MockDecryptPasswordUseCase mockDecryptPasswordUseCase;

  const tUserId = 'user123';
  final tPlatformData = PlatformData(
    name: 'Facebook',
    icon: 'icon_url',
    website: 'facebook.com',
  );
  final tAccount1 = PlatformAccount(
    id: '1',
    platform: tPlatformData,
    identifier: 'test@example.com',
    password: const EncryptedData(
      cipherText: [1, 2, 3],
      mac: [4, 5, 6],
      nonce: [7, 8, 9],
    ),
    createdAt: DateTime.now(),
  );
  final tAccount2 = PlatformAccount(
    id: '2',
    platform: tPlatformData,
    identifier: 'test@example.com',
    password: const EncryptedData(
      cipherText: [1, 55, 3],
      mac: [4, 88, 6],
      nonce: [7, 8, 3],
    ),
    createdAt: DateTime.now(),
  );
  const tFailure = ServerFailure('error_message');

  setUpAll(() {
    registerFallbackValue(FakeEncryptedData());
  });

  setUp(() {
    mockGetAccountsUseCase = MockGetAccountsUseCase();
    mockDecryptPasswordUseCase = MockDecryptPasswordUseCase();
    homeCubit = HomeCubit(mockGetAccountsUseCase, mockDecryptPasswordUseCase);

    // Setup Clipboard mock to prevent errors during tests
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  tearDown(() {
    homeCubit.close();
  });

  test('initial state should be HomeInitial', () {
    expect(homeCubit.state, isA<HomeInitial>());
  });

  group('getAccounts', () {
    blocTest<HomeCubit, HomeState>(
      'emits [HomeLoading, HomeSuccess] when successful',
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
      },
    );

    blocTest<HomeCubit, HomeState>(
      'emits [HomeLoading, HomeError] when failure happens',
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
      },
    );

    blocTest<HomeCubit, HomeState>(
      'emits [HomeLoading] and ignores error if message contains permission-denied',
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
      },
    );

    blocTest<HomeCubit, HomeState>(
      'emits HomeError when stream throws non permission error',
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

  group('copyAccountPassword', () {
    test('calls decrypt and copies password to clipboard', () async {
      when(
        () => mockDecryptPasswordUseCase.invoke(any()),
      ).thenAnswer((_) async => Right('decrypted_password'));

      await homeCubit.copyAccountPassword(account: tAccount1);

      verify(() => mockDecryptPasswordUseCase.invoke(any())).called(1);
    });

    test('throws exception when decryption fails', () async {
      // Arrange
      final exception = Exception('decryption_failed');

      when(() => mockDecryptPasswordUseCase.invoke(any())).thenThrow(exception);

      // Act & Assert
      await expectLater(
        homeCubit.copyAccountPassword(account: tAccount1),
        throwsA(same(exception)),
      );

      verify(() => mockDecryptPasswordUseCase.invoke(any())).called(1);
    });
  });

  group('clearHomeAccounts', () {
    blocTest<HomeCubit, HomeState>(
      'clears accounts list and emits HomeInitial',
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
