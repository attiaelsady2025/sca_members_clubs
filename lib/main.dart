import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';
import 'core/di/injection_container.dart' as di;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sca_members_clubs/features/home/presentation/cubit/navigation_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthCubit>()),
        BlocProvider(create: (context) => NavigationCubit()),
      ],
      child: const SCAMembersApp(),
    ),
  );
}

class SCAMembersApp extends StatelessWidget {
  const SCAMembersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appNameEn,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: Routes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
