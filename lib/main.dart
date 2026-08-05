import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:pb_vault/features/auth/screens/auth_screen.dart';
import 'package:pb_vault/features/auth/screens/reset_password_screen.dart';
import 'package:pb_vault/features/edit_profile/screens/edit_profile_screen.dart';
import 'package:pb_vault/features/home_screen/screens/home_screen.dart';
import 'package:pb_vault/features/master_password_screen/cubit/master_password_view_model.dart';
import 'package:pb_vault/features/master_password_screen/screens/biometrics_screen.dart';
import 'package:pb_vault/features/master_password_screen/screens/master_password_screen.dart';
import 'package:pb_vault/features/master_password_screen/screens/pick_avatar_screen.dart';
import 'package:pb_vault/features/profile_screen/screens/change_master_password_screen.dart';
import 'package:provider/provider.dart';

import 'core/di/di.dart';
import 'core/utils/app_routes.dart';
import 'core/utils/app_theme.dart';
import 'core/utils/bloc_observer.dart';
import 'domain/use_cases/set_onboarding_done_use_case.dart';
import 'features/auth/cubit/user_view_model.dart';
import 'features/home_screen/cubit/home_view_model.dart';
import 'features/onboarding_screen/provider/onboarding_view_model.dart';
import 'features/onboarding_screen/screens/onboarding_screen.dart';
import 'features/platform_account/cubit/platform_account_view_model.dart';
import 'features/platform_account/screens/add_platform_account_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    EasyLocalization.ensureInitialized(),
    EasyTheme.ensureInitialized(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
  configureDependencies();
  Bloc.observer = MyBlocObserver();
  runApp(
    EasyTheme(
      darkTheme: AppTheme.darkTheme,
      lightTheme: AppTheme.lightTheme,
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: Locale('en'),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<UserCubit>()),
            BlocProvider(create: (context) => getIt<HomeCubit>()),
            BlocProvider(create: (context) => getIt<PlatformAccountCubit>()),
            BlocProvider(create: (context) => getIt<MasterPasswordCubit>()),
          ],
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: context.read<UserCubit>().getInitialRoute(),
      routes: {
        AppRoutes.onboardingRouteName: (context) => ChangeNotifierProvider(
          create: (context) =>
              OnboardingViewModel(getIt<SetOnboardingDoneUseCase>()),

          child: const OnboardingScreen(),
        ),
        AppRoutes.authScreen: (context) => const AuthScreen(),
        AppRoutes.homeRouteName: (context) => const HomeScreen(),
        AppRoutes.masterPasswordScreen: (context) =>
            const MasterPasswordScreen(),
        AppRoutes.addAccountScreen: (context) =>
            const AddPlatformAccountScreen(),
        AppRoutes.editProfileScreen: (context) => const EditProfileScreen(),
        AppRoutes.biometricsScreen: (context) => const BiometricsScreen(),
        AppRoutes.pickAvatarScreen: (context) => const PickAvatarScreen(),
        AppRoutes.resetPasswordScreen: (context) => const ResetPasswordScreen(),
        AppRoutes.changeMasterPasswordScreen: (context) =>
            const ChangeMasterPasswordScreen(),
      },
      themeMode: context.themeMode,
      darkTheme: context.darkTheme,
      theme: context.lightTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
