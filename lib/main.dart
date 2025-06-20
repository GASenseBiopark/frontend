import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/pages/auth/log_in.dart';
import 'package:gasense/pages/auth/welcome.dart';
import 'package:gasense/pages/navegation/home.dart';
import 'package:gasense/pages/navegation/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Mensagem recebida em background: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Registrar handler para notificações em background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final prefs = await SharedPreferences.getInstance();
  final idUsuario = prefs.getInt('id_usuario');

  runApp(GASense(isLoggedIn: idUsuario != null));
}

class GASense extends StatefulWidget {
  final bool isLoggedIn;
  const GASense({super.key, required this.isLoggedIn});

  @override
  State<GASense> createState() => _GASenseState();
}

class _GASenseState extends State<GASense> {
  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() async {
    // Web, iOS e Android (tudo unificado com FlutterFire)
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permissão concedida para receber notificações');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('Permissão negada');
    } else {
      print('Permissão: ${settings.authorizationStatus}');
    }

    // Obter token (serve para web também)
    String? token = await FirebaseMessaging.instance.getToken();
    print('Token FCM: $token');

    // Ouvir mensagens no foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensagem recebida no foreground: ${message.messageId}');
    });

    // Ouvir quando usuário abre o app pela notificação
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notificação clicada: ${message.messageId}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'BioLab Monitor',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: AppColors.grey,
          onSecondary: Colors.white,
          surface: AppColors.grey200,
          onSurface: const Color.fromARGB(255, 255, 255, 255),
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
      home: widget.isLoggedIn ? const HomePage() : const WelcomePage(),
    );
  }
}
