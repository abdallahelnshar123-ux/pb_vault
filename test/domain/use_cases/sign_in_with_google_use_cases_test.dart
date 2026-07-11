import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/user/my_user.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/auth/auth_repository.dart';
import 'package:pb_vault/domain/use_cases/sign_in_with_google_use_cases.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late ContinueWithGoogleUseCases useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = ContinueWithGoogleUseCases(mockAuthRepository);
  });

  const tMyUser = MyUser(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
    provider: 'google',
  );

  const tFailure = ServerFailure('Server Error');

  test('should call continueWithGoogle from AuthRepository', () async {
    // Arrange
    when(() => mockAuthRepository.continueWithGoogle())
        .thenAnswer((_) async => const Right(tMyUser));

    // Act
    final result = await useCase.invoke();

    // Assert
    expect(result, const Right(tMyUser));
    verify(() => mockAuthRepository.continueWithGoogle()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Failure when AuthRepository returns Failure', () async {
    // Arrange
    when(() => mockAuthRepository.continueWithGoogle())
        .thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase.invoke();

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockAuthRepository.continueWithGoogle()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}

// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:pb_vault/domain/entities/response/user/my_user.dart';
// import 'package:pb_vault/domain/failure/failure.dart';
// import 'package:pb_vault/domain/repository/auth/auth_repository.dart';
// import 'package:pb_vault/domain/use_cases/sign_in_with_google_use_cases.dart';
//
// class MockAuthRepo extends Mock implements AuthRepository {}
//
// void main() {
//   late final MockAuthRepo mockAuthRepo;
//   late final ContinueWithGoogleUseCases continueWithGoogleUseCases;
//   setUp(() {
//     mockAuthRepo = MockAuthRepo();
//     continueWithGoogleUseCases = ContinueWithGoogleUseCases(mockAuthRepo);
//   });
//   test(
//     'should call authRepo.continueWithGoogle and return Right<MyUser>',
//     () async {
//       when(
//         () => mockAuthRepo.continueWithGoogle(),
//       ).thenAnswer((_) async => Right(MyUser.emptyUser()));
//
//       final result = await continueWithGoogleUseCases.invoke();
//
//       expect(result, Right(MyUser.emptyUser()));
//       verify(() => mockAuthRepo.continueWithGoogle()).called(1);
//       verifyNoMoreInteractions(mockAuthRepo);
//     },
//   );
//   test(
//     'should call authRepo.continueWithGoogle and return Left<Failure>',
//         () async {
//       const Failure failure = ServerFailure('error');
//       when(
//             () => mockAuthRepo.continueWithGoogle(),
//       ).thenAnswer((_) async => Left(failure));
//
//       final result = await continueWithGoogleUseCases.invoke();
//
//       expect(result, Left(failure));
//       verify(() => mockAuthRepo.continueWithGoogle()).called(1);
//       verifyNoMoreInteractions(mockAuthRepo);
//     },
//   );
// }
