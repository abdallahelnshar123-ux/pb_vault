import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/user/my_user.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/user/user_repository.dart';
import 'package:pb_vault/domain/use_cases/set_master_password_use_case.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockUserRepo;
  late SetMasterPasswordUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const MyUser(
      id: '',
      email: '',
      name: '',
      provider: '',
    ));
  });

  setUp(() {
    mockUserRepo = MockUserRepository();
    useCase = SetMasterPasswordUseCase(mockUserRepo);
  });

  const tMyUser = MyUser(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
    provider: 'google',
  );

  test('should call UserRepository.setMasterPassword and return Right(unit)', () async {
    // Arrange
    when(() => mockUserRepo.setMasterPassword(user: any(named: 'user')))
        .thenAnswer((_) async => const Right(unit));

    // Act
    final result = await useCase.invoke(user: tMyUser);

    // Assert
    expect(result, const Right(unit));
    verify(() => mockUserRepo.setMasterPassword(user: tMyUser)).called(1);
    verifyNoMoreInteractions(mockUserRepo);
  });

  test('should return Failure when UserRepository.setMasterPassword fails', () async {
    // Arrange
    const tFailure = ServerFailure('Update Error');
    when(() => mockUserRepo.setMasterPassword(user: any(named: 'user')))
        .thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase.invoke(user: tMyUser);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockUserRepo.setMasterPassword(user: tMyUser)).called(1);
    verifyNoMoreInteractions(mockUserRepo);
  });
}
