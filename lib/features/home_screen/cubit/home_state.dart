import '../../../domain/entities/response/account/account.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<Account> accounts;
  HomeSuccess(this.accounts);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
