import 'package:flutter/cupertino.dart';

import '../../../domain/entities/response/platform_account/login_method.dart';
import '../../../domain/entities/response/platform_account/platform_data.dart';

class PlatformAccountController {
  final identifier = TextEditingController();
  final password = TextEditingController();
  final notes = TextEditingController();
  final recoveryCodes = TextEditingController();
  final passkey = TextEditingController();

  final currentPlatform = ValueNotifier<PlatformData?>(null);

  List<LoginMethod> loginMethods = [];

  void dispose() {
    identifier.dispose();
    password.dispose();
    notes.dispose();
    recoveryCodes.dispose();
    passkey.dispose();
    currentPlatform.dispose();
  }
}
