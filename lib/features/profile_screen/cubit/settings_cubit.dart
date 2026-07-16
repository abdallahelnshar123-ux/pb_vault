import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/domain/use_cases/get_app_settings_use_case.dart';
import 'package:pb_vault/features/profile_screen/cubit/settings_state.dart';

import '../../../domain/use_cases/biometric/enable_biometric_use_case.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final EnableBiometricUseCase _enableBiometricUseCase;
  final GetAppSettingsUseCase _appSettingsUseCase;

  SettingsCubit(this._enableBiometricUseCase, this._appSettingsUseCase)
    : super(SettingsState());

  void loadSettings({required Locale currentLocale}) async {
    final settings = await _appSettingsUseCase.invoke();
    emit(
      state.copyWith(
        locale: currentLocale,
        // todo : remember to make theme dynamic
        themeMode: ThemeMode.dark,
        isBiometricEnabled: settings.isBiometricEnabled,
        isBiometricSupported: settings.isBiometricSupported,
      ),
    );
  }

  Future<void> toggleBiometric(bool value) async {
    final result = await _enableBiometricUseCase.invoke(value);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => emit(state.copyWith(isBiometricEnabled: value)),
    );
  }

  void changeLanguage({required Locale newLocale}) {
    emit(state.copyWith(locale: newLocale));
  }
}
