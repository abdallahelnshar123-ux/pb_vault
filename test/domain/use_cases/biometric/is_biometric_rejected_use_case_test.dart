import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/biometric/biometric_repository.dart';
import 'package:pb_vault/domain/use_cases/biometric/is_biometric_rejected_use_case.dart';

class MockBiometricRepository extends Mock implements BiometricRepository {}

void main() {
  late MockBiometricRepository mockBiometricRepository;
  late IsBiometricRejectedUseCase useCase;

  setUp(() {
    mockBiometricRepository = MockBiometricRepository();
    useCase = IsBiometricRejectedUseCase(mockBiometricRepository);
  });

  group('IsBiometricRejectedUseCase', () {
    test('should return Right(true) when repository returns Right(true)', () {
      // arrange
      when(() => mockBiometricRepository.isBiometricRejected())
          .thenReturn(const Right(true));

      // act
      final result = useCase.invoke();

      // assert
      expect(result, const Right(true));
      verify(() => mockBiometricRepository.isBiometricRejected()).called(1);
      verifyNoMoreInteractions(mockBiometricRepository);
    });

    test('should return Right(false) when repository returns Right(false)', () {
      // arrange
      when(() => mockBiometricRepository.isBiometricRejected())
          .thenReturn(const Right(false));

      // act
      final result = useCase.invoke();

      // assert
      expect(result, const Right(false));
      verify(() => mockBiometricRepository.isBiometricRejected()).called(1);
      verifyNoMoreInteractions(mockBiometricRepository);
    });

    test('should return Left(Failure) when repository returns Left(Failure)', () {
      // arrange
      const tFailure = UnexpectedFailure('Error');
      when(() => mockBiometricRepository.isBiometricRejected())
          .thenReturn(const Left(tFailure));

      // act
      final result = useCase.invoke();

      // assert
      expect(result, const Left(tFailure));
      verify(() => mockBiometricRepository.isBiometricRejected()).called(1);
      verifyNoMoreInteractions(mockBiometricRepository);
    });
  });
}
