import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/firebase_options.dart';
import 'package:gasense/pages/auth/log_in.dart';
import 'package:gasense/pages/auth/tela_carregamento.dart';
import 'package:gasense/pages/navegation/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const GASense());
}

class GASense extends StatelessWidget {
  const GASense({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GASense',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.white,
          onPrimary: const Color.fromARGB(255, 255, 255, 255),
          secondary: AppColors.grey,
          onSecondary: Colors.white,
          surface: AppColors.grey200,
          onSurface: const Color.fromARGB(255, 255, 255, 255),
          error: Colors.red,
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          foregroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          shape: CircleBorder(),
        ),
        cardTheme: CardTheme(
          color: AppColors.white,
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
      home: const LogInPage(),
    );
  }
}
