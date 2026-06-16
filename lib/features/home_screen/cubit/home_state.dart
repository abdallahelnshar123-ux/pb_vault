import '../../../domain/entities/response/platform_account/platform_account.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<PlatformAccount> accounts;
  HomeSuccess(this.accounts);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
