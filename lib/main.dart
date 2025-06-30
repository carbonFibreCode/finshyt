
import 'package:finshyt/constants/app_colors.dart';
import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:finshyt/init_dependencies.dart';
import 'package:finshyt/routes/routes.dart';
import 'package:finshyt/screens/auth/auth_screen.dart';
import 'package:finshyt/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:finshyt/screens/homeScreen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initDependencies();
  runApp(

    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()..add(AuthEventIsUserLoggedIn())),
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'FinShyt',
      theme: ThemeData(
        fontFamily: GoogleFonts.inter().fontFamily,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.primary,
          onPrimary: AppColors.icons,
          secondary: AppColors.secondary,
          onSecondary: AppColors.secondaryText,
          error: AppColors.warnings,
          onError: AppColors.background,
          surface: AppColors.background,
          onSurface: AppColors.icons,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        scaffoldBackgroundColor: AppColors.primary,
        useMaterial3: true,
      ),
      initialRoute: '/',                  
      onGenerateRoute: RouteGenerator.generate,
      debugShowCheckedModeBanner: false,

      home: const NavigationHandler(),
    );
  }
}

class NavigationHandler extends StatefulWidget {
  const NavigationHandler({super.key});

  @override
  State<NavigationHandler> createState() => _NavigationHandlerState();
}

class _NavigationHandlerState extends State<NavigationHandler> {
  @override
  void initState() {
    super.initState();

    context.read<AuthBloc>().add(const AuthEventIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppUserCubit, AppUserState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        if (state is AppUserLoggedIn) {
          return const HomePage();
        } else {
          return const Login();
        }
      },
    );
  }
}
