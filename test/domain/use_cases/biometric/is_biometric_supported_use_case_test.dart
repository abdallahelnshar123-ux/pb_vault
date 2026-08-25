import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/biometric/biometric_repository.dart';
import 'package:pb_vault/domain/use_cases/biometric/is_biometric_supported_use_case.dart';

class MockBiometricRepository extends Mock implements BiometricRepository {}

void main() {
  late MockBiometricRepository mockBiometricRepository;
  late IsBiometricSupportedUseCase useCase;

  setUp(() {
    mockBiometricRepository = MockBiometricRepository();
    useCase = IsBiometricSupportedUseCase(mockBiometricRepository);
  });

  group('IsBiometricSupportedUseCase', () {
    test('should return Right(true) when repository returns Right(true)', () async {
      // arrange
      when(() => mockBiometricRepository.isBiometricSupported())
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await useCase.invoke();

      // assert
      expect(result, const Right(true));
      verify(() => mockBiometricRepository.isBiometricSupported()).called(1);
      verifyNoMoreInteractions(mockBiometricRepository);
    });

    test('should return Right(false) when repository returns Right(false)', () async {
      // arrange
      when(() => mockBiometricRepository.isBiometricSupported())
          .thenAnswer((_) async => const Right(false));

      // act
      final result = await useCase.invoke();

      // assert
      expect(result, const Right(false));
      verify(() => mockBiometricRepository.isBiometricSupported()).called(1);
    });

    test('should return Left(Failure) when repository returns Left(Failure)', () async {
      // arrange
      const tFailure = UnexpectedFailure('Error');
      when(() => mockBiometricRepository.isBiometricSupported())
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase.invoke();

      // assert
      expect(result, const Left(tFailure));
      verify(() => mockBiometricRepository.isBiometricSupported()).called(1);
    });
  });
}
