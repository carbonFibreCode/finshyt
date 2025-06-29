
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
    // Step 1: Provide all Blocs at the very top of the widget tree.
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
      ],
      // Step 2: The root of your application is MyApp.
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Step 3: MaterialApp provides the theme, routing, and directionality.
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
      initialRoute: '/',                  // your home route
      onGenerateRoute: RouteGenerator.generate,
      // Step 4: The home of your app is the NavigationHandler, which will decide what to show.
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
    // Dispatch the initial event to check if the user is logged in.
    context.read<AuthBloc>().add(const AuthEventIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    // Step 5: This listener handles navigation side-effects.
    return BlocConsumer<AppUserCubit, AppUserState>(
      listener: (context, state) {
        // Handle side effects only - NO navigation here
        print('DEBUG: AppUserCubit state changed to: $state');
      },
      builder: (context, state) {
        print('DEBUG: BlocConsumer builder called, state: $state');
        if (state is AppUserLoggedIn) {
          return const HomePage();
        } else {
          return const Login();
        }
      },
    );
  }
}
