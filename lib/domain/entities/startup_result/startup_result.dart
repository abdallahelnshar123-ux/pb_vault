import '../response/user/my_user.dart';

class StartupResult {
  final StartupStatus status;
  final MyUser? user;

  StartupResult(this.status, this.user);
}

enum StartupStatus { onboarding, unauthenticated, authenticated }
