import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pb_vault/features/add_account/screens/add_account_screen.dart';
import 'package:pb_vault/features/auth/screens/auth_screen.dart';
import 'package:pb_vault/features/edit_profile/screens/edit_profile_screen.dart';
import 'package:pb_vault/features/home_screen/screens/home_screen.dart';
import 'package:pb_vault/features/master_password_screen/screens/master_password_screen.dart';
import 'package:provider/provider.dart';

import 'core/di/di.dart';
import 'core/utils/app_routes.dart';
import 'core/utils/app_theme.dart';
import 'domain/use_cases/set_onboarding_done_use_case.dart';
import 'features/auth/cubit/auth_view_model.dart';
import 'features/onboarding_screen/provider/onboarding_view_model.dart';
import 'features/onboarding_screen/screens/onboarding_screen.dart';
import 'features/profile_screen/screens/profile_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => getIt<AuthCubit>())],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: Locale('en'),
        child: const MyApp(),
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
      initialRoute: context.read<AuthCubit>().getInitialRoute(),
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
        AppRoutes.addAccountScreen: (context) => const AddAccountScreen(),
        AppRoutes.profileScreen: (context) => const ProfileScreen(),
        AppRoutes.editProfileScreen: (context) => const EditProfileScreen(),
      },
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
