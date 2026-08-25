import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  final bool? isBiometricEnabled;
  final bool? isBiometricSupported;
  final ThemeMode? themeMode;
  final Locale? locale;

  const AppSettings({
    this.locale,
    this.themeMode,
    this.isBiometricEnabled,
    this.isBiometricSupported,
  });

  @override
  List<Object?> get props => [
    isBiometricEnabled,
    isBiometricSupported,
    themeMode,
    locale,
  ];
}
