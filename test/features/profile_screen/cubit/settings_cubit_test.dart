import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/settings/settings.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/use_cases/biometric/enable_biometric_use_case.dart';
import 'package:pb_vault/domain/use_cases/get_app_settings_use_case.dart';
import 'package:pb_vault/features/profile_screen/cubit/settings_cubit.dart';
import 'package:pb_vault/features/profile_screen/cubit/settings_state.dart';

class MockEnableBiometricUseCase extends Mock implements EnableBiometricUseCase {}

class MockGetAppSettingsUseCase extends Mock implements GetAppSettingsUseCase {}

void main() {
  late SettingsCubit settingsCubit;
  late MockEnableBiometricUseCase mockEnableBiometricUseCase;
  late MockGetAppSettingsUseCase mockGetAppSettingsUseCase;

  const tLocale = Locale('en');
  const tNewLocale = Locale('ar');
  const tAppSettings = AppSettings(
    isBiometricEnabled: true,
    isBiometricSupported: true,
  );
  const tFailure = BiometricFailure('biometric_error');

  setUp(() {
    mockEnableBiometricUseCase = MockEnableBiometricUseCase();
    mockGetAppSettingsUseCase = MockGetAppSettingsUseCase();
    settingsCubit = SettingsCubit(
      mockEnableBiometricUseCase,
      mockGetAppSettingsUseCase,
    );
  });

  tearDown(() {
    settingsCubit.close();
  });

  test('initial state should be SettingsState with default values', () {
    expect(settingsCubit.state, const SettingsState());
  });

  group('loadSettings', () {
    blocTest<SettingsCubit, SettingsState>(
      'should emit SettingsState with loaded settings when loadSettings is called',
      build: () {
        when(() => mockGetAppSettingsUseCase.invoke())
            .thenAnswer((_) async => tAppSettings);
        return settingsCubit;
      },
      act: (cubit) => cubit.loadSettings(currentLocale: tLocale),
      expect: () => [
        const SettingsState(
          locale: tLocale,
          isBiometricEnabled: true,
          isBiometricSupported: true,
        ),
      ],
      verify: (_) {
        verify(() => mockGetAppSettingsUseCase.invoke()).called(1);
        verifyNoMoreInteractions(mockGetAppSettingsUseCase);
        verifyZeroInteractions(mockEnableBiometricUseCase);
      },
    );
  });

  group('toggleBiometric', () {
    blocTest<SettingsCubit, SettingsState>(
      'should emit updated isBiometricEnabled when toggleBiometric is successful',
      build: () {
        when(() => mockEnableBiometricUseCase.invoke(any()))
            .thenAnswer((_) async => const Right(unit));
        return settingsCubit;
      },
      act: (cubit) => cubit.toggleBiometric(true),
      expect: () => [
        const SettingsState(isBiometricEnabled: true),
      ],
      verify: (_) {
        verify(() => mockEnableBiometricUseCase.invoke(true)).called(1);
        verifyNoMoreInteractions(mockEnableBiometricUseCase);
        verifyZeroInteractions(mockGetAppSettingsUseCase);
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'should emit errorMessage when toggleBiometric fails',
      build: () {
        when(() => mockEnableBiometricUseCase.invoke(any()))
            .thenAnswer((_) async => const Left(tFailure));
        return settingsCubit;
      },
      act: (cubit) => cubit.toggleBiometric(false),
      expect: () => [
        const SettingsState(errorMessage: 'biometric_error'),
      ],
      verify: (_) {
        verify(() => mockEnableBiometricUseCase.invoke(false)).called(1);
        verifyNoMoreInteractions(mockEnableBiometricUseCase);
        verifyZeroInteractions(mockGetAppSettingsUseCase);
      },
    );
  });

  group('changeLanguage', () {
    blocTest<SettingsCubit, SettingsState>(
      'should emit updated locale when changeLanguage is called',
      build: () => settingsCubit,
      act: (cubit) => cubit.changeLanguage(newLocale: tNewLocale),
      expect: () => [
        const SettingsState(locale: tNewLocale),
      ],
      verify: (_) {
        verifyZeroInteractions(mockEnableBiometricUseCase);
        verifyZeroInteractions(mockGetAppSettingsUseCase);
      },
    );
  });
}
