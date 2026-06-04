import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/di.dart';
import 'core/utils/app_routes.dart';
import 'core/utils/app_theme.dart';
import 'features/auth/cubit/auth_view_model.dart';
import 'features/auth/login_screen/view/login_screen.dart';
import 'features/auth/register_screen/view/register_screen.dart';
import 'firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: MyApp(),
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
        // AppRoutes.onboardingRouteName: (context) => ChangeNotifierProvider(
        //   create: (context) =>
        //       OnboardingViewModel(getIt<SetOnboardingDoneUseCase>()),
        //   child: OnboardingScreen(),
        // ),
        AppRoutes.loginRouteName: (context) => LoginScreen(),
        // AppRoutes.resetPasswordRouteName: (context) => ResetPasswordScreen(),
        AppRoutes.registerRouteName: (context) => RegisterScreen(),

      },
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

