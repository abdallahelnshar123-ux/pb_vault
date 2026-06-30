import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_data.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/account/account_repository.dart';
import 'package:pb_vault/domain/use_cases/add_account_use_case.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late MockAccountRepository mockAccountRepo;
  late AddPlatformAccountUseCase accountUseCase;

  setUpAll(() {
    registerFallbackValue(PlatformAccount(
      platform: const PlatformData(name: 'name', icon: 'icon', website: 'icon'),
      emailOrUsername: 'email',
      encryptedPassword: const [],
      createdAt: DateTime.now(),
      mac: const [],
      nonce: const [],
    ));
  });

  setUp(() {
    mockAccountRepo = MockAccountRepository();
    accountUseCase = AddPlatformAccountUseCase(mockAccountRepo);
  });

  const tUserId = '1';
  final tAccount = PlatformAccount(
    platform: const PlatformData(name: 'name', icon: 'icon', website: 'icon'),
    emailOrUsername: 'email',
    encryptedPassword: const [4, 5, 6],
    createdAt: DateTime.now(),
    mac: const [3, 6, 9],
    nonce: const [3, 2, 4],
  );

  test('should call accountRepo.addAccount and return Right<unit>', () async {
    // Arrange
    when(() => mockAccountRepo.addAccount(any(), any()))
        .thenAnswer((_) async => const Right(unit));

    // Act
    final result = await accountUseCase.invoke(tUserId, tAccount);

    // Assert
    expect(result, const Right(unit));
    verify(() => mockAccountRepo.addAccount(tUserId, tAccount)).called(1);
    verifyNoMoreInteractions(mockAccountRepo);
  });

  test('should call accountRepo.addAccount and return Left<Failure>', () async {
    // Arrange
    const tFailure = ServerFailure('Server Error');
    when(() => mockAccountRepo.addAccount(any(), any()))
        .thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await accountUseCase.invoke(tUserId, tAccount);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockAccountRepo.addAccount(tUserId, tAccount)).called(1);
    verifyNoMoreInteractions(mockAccountRepo);
  });
}

// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
// import 'package:pb_vault/domain/entities/response/platform_account/platform_data.dart';
// import 'package:pb_vault/domain/failure/failure.dart';
// import 'package:pb_vault/domain/repository/account/account_repository.dart';
// import 'package:pb_vault/domain/use_cases/add_account_use_case.dart';
//
// class MockAccountRepo extends Mock implements AccountRepository {}
//
// void main() {
//   late final MockAccountRepo mockAccountRepo;
//   late final AddPlatformAccountUseCase addPlatformAccountUseCase;
//
//   setUpAll(() {
//     registerFallbackValue(
//       PlatformAccount(
//         platform: const PlatformData(
//           name: 'name',
//           icon: 'icon',
//           website: 'icon',
//         ),
//         emailOrUsername: 'email',
//         encryptedPassword: const [],
//         createdAt: DateTime.now(),
//         mac: const [],
//         nonce: const [],
//       ),
//     );
//   });
//   setUp(() {
//     mockAccountRepo = MockAccountRepo();
//     addPlatformAccountUseCase = AddPlatformAccountUseCase(mockAccountRepo);
//   });
//   const tUserId = '1';
//   final tAccount = PlatformAccount(
//     platform: const PlatformData(name: 'name', icon: 'icon', website: 'icon'),
//     emailOrUsername: 'email',
//     encryptedPassword: const [4, 5, 6],
//     createdAt: DateTime.now(),
//     mac: const [3, 6, 9],
//     nonce: const [3, 2, 4],
//   );
//
//   test(
//     'should call accountRepository.addAccount and return Right<unit>',
//     () async {
//       when(
//         () => mockAccountRepo.addAccount(any(), any()),
//       ).thenAnswer((_) async => Right(unit));
//
//       final result = await addPlatformAccountUseCase.invoke(tUserId, tAccount);
//
//       expect(result, Right(unit));
//       verify(() => mockAccountRepo.addAccount(tUserId, tAccount)).called(1);
//       verifyNoMoreInteractions(mockAccountRepo);
//     },
//   );
//   test(
//     'should call accountRepository.addAccount and return Left<Failure>',
//     () async {
//       const Failure failure = ServerFailure('error');
//       when(
//         () => mockAccountRepo.addAccount(any(), any()),
//       ).thenAnswer((_) async => Left(failure));
//
//       final result = await addPlatformAccountUseCase.invoke(tUserId, tAccount);
//
//       expect(result, Left(failure));
//       verify(() => mockAccountRepo.addAccount(tUserId, tAccount)).called(1);
//       verifyNoMoreInteractions(mockAccountRepo);
//     },
//   );
// }
