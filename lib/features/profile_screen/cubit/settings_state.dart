import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final bool isBiometricEnabled;
  final bool isBiometricSupported;
  final ThemeMode themeMode;
  final Locale locale;
  final String? errorMessage;

  const SettingsState({
    this.isBiometricSupported = false,
    this.isBiometricEnabled = false,
    this.themeMode = ThemeMode.dark,
    this.locale = const Locale('en'),
    this.errorMessage,
  });

  SettingsState copyWith({
    bool? isBiometricEnabled,
    bool? isBiometricSupported,

    ThemeMode? themeMode,
    Locale? locale,
    String? errorMessage,
  }) {
    return SettingsState(
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isBiometricSupported: isBiometricSupported ?? this.isBiometricSupported,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isBiometricEnabled,
    themeMode,
    locale,
    errorMessage,
  ];
}
