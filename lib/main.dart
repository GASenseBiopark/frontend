import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/pages/auth/log_in.dart';
import 'package:gasense/pages/auth/welcome.dart';
import 'package:gasense/pages/navegation/home.dart';
import 'package:gasense/pages/navegation/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final idUsuario = prefs.getInt('id_usuario');

  runApp(BioLabApp(isLoggedIn: idUsuario != null));
}

class BioLabApp extends StatelessWidget {
  final bool isLoggedIn;
  const BioLabApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'BioLab Monitor',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.white, // cor principal clara
          onPrimary: Colors.black, // texto sobre branco

          secondary: AppColors.grey, // cor de destaque secundária
          onSecondary: Colors.white, // texto sobre elementos secundários

          surface: AppColors.grey200, // elementos neutros como cards
          onSurface: const Color.fromARGB(
            255,
            255,
            255,
            255,
          ), // texto sobre surface

          error: Colors.red,
          onError: Colors.white,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          centerTitle: true,
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.grey,
          foregroundColor: Colors.white,
          shape: CircleBorder(),
        ),

        cardTheme: CardTheme(
          color: AppColors.grey200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: AppColors.grey),
          titleLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(color: AppColors.grey),
        ),
      ),
      // home: isLoggedIn ? const HomePage() : const WelcomePage(),
      home: LogInPage(),
    );
  }
}
