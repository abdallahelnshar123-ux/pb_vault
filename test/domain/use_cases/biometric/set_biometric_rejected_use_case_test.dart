import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/biometric/biometric_repository.dart';
import 'package:pb_vault/domain/use_cases/biometric/set_biometric_rejected_use_case.dart';

class MockBiometricRepository extends Mock implements BiometricRepository {}

void main() {
  late MockBiometricRepository mockBiometricRepository;
  late SetBiometricRejectedUseCase useCase;

  setUp(() {
    mockBiometricRepository = MockBiometricRepository();
    useCase = SetBiometricRejectedUseCase(mockBiometricRepository);
  });

  group('SetBiometricRejectedUseCase', () {
    const tEnabled = true;

    test('should call setBiometricRejected on repository with correct arguments', () async {
      // arrange
      when(() => mockBiometricRepository.setBiometricRejected(any()))
          .thenAnswer((_) async => const Right(unit));

      // act
      await useCase.invoke(tEnabled);

      // assert
      verify(() => mockBiometricRepository.setBiometricRejected(tEnabled)).called(1);
    });

    test('should return Right(unit) when repository call is successful', () async {
      // arrange
      when(() => mockBiometricRepository.setBiometricRejected(any()))
          .thenAnswer((_) async => const Right(unit));

      // act
      final result = await useCase.invoke(tEnabled);

      // assert
      expect(result, const Right(unit));
      verify(() => mockBiometricRepository.setBiometricRejected(tEnabled)).called(1);
      verifyNoMoreInteractions(mockBiometricRepository);
    });

    test('should return Left(Failure) when repository call fails', () async {
      // arrange
      const tFailure = UnexpectedFailure('Error');
      when(() => mockBiometricRepository.setBiometricRejected(any()))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase.invoke(tEnabled);

      // assert
      expect(result, const Left(tFailure));
      verify(() => mockBiometricRepository.setBiometricRejected(tEnabled)).called(1);
      verifyNoMoreInteractions(mockBiometricRepository);
    });
  });
}
