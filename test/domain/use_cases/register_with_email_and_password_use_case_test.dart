import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/user/my_user.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/auth/auth_repository.dart';
import 'package:pb_vault/domain/use_cases/register_with_email_and_password_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepo;
  late RegisterWithEmailAndPasswordUseCase useCase;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    useCase = RegisterWithEmailAndPasswordUseCase(mockAuthRepo);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tName = 'Test User';
  const tAvatarIndex = 1;
  const tMyUser = MyUser(
    id: '1',
    email: tEmail,
    name: tName,
    provider: 'email',
  );

  test('should call AuthRepository.registerWithEmailAndPassword and return Right(MyUser)', () async {
    // Arrange
    when(() => mockAuthRepo.registerWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
      name: any(named: 'name'),
      avatarIndex: any(named: 'avatarIndex'),
    )).thenAnswer((_) async => const Right(tMyUser));

    // Act
    final result = await useCase.invoke(
      email: tEmail,
      password: tPassword,
      name: tName,
      avatarIndex: tAvatarIndex,
    );

    // Assert
    expect(result, const Right(tMyUser));
    verify(() => mockAuthRepo.registerWithEmailAndPassword(
      email: tEmail,
      password: tPassword,
      name: tName,
      avatarIndex: tAvatarIndex,
    )).called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });

  test('should return Failure when AuthRepository.registerWithEmailAndPassword fails', () async {
    // Arrange
    const tFailure = ServerFailure('Register Error');
    when(() => mockAuthRepo.registerWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
      name: any(named: 'name'),
      avatarIndex: any(named: 'avatarIndex'),
    )).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase.invoke(
      email: tEmail,
      password: tPassword,
      name: tName,
      avatarIndex: tAvatarIndex,
    );

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockAuthRepo.registerWithEmailAndPassword(
      email: tEmail,
      password: tPassword,
      name: tName,
      avatarIndex: tAvatarIndex,
    )).called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });
}
