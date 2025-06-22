import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/firebase_options.dart';
import 'package:gasense/pages/auth/welcome.dart';
import 'package:gasense/pages/navegation/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaCarregamento extends StatefulWidget {
  const TelaCarregamento({super.key});

  @override
  State<TelaCarregamento> createState() => _TelaCarregamentoState();
}

class _TelaCarregamentoState extends State<TelaCarregamento> {
  bool? isLoggedIn;

  // Cria a instância do flutter_local_notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _initializeLocalNotifications();
    await _setupFirebaseMessaging();

    final prefs = await SharedPreferences.getInstance();
    final idUsuario = prefs.getInt('id_usuario');
    setState(() {
      isLoggedIn = idUsuario != null;
    });
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _setupFirebaseMessaging() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permissão concedida para notificações');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('Permissão negada');
    }

    String? token = await FirebaseMessaging.instance.getToken();
    print('Token FCM: $token');

    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      print('Token salvo no SharedPreferences');
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print('Novo token FCM: $newToken');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', newToken);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensagem foreground: ${message.messageId}');

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'canal_alertas', // ID do canal (pode ser qualquer string)
              'Alertas',
              channelDescription: 'Canal de alertas do sistema',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notificação clicada: ${message.messageId}');
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Mensagem background: ${message.messageId}');
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              transform: GradientRotation(1),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 236, 236, 236),
              ],
            ),
          ),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text('Carregando...', style: AppText.texto),
              ],
            ),
          ),
        ),
      );
    } else {
      return isLoggedIn! ? const HomePage() : const WelcomePage();
    }
  }
}
