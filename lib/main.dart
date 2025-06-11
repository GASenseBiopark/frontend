import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/pages/auth/welcome.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() => runApp(const BioLabApp());

class BioLabApp extends StatelessWidget {
  const BioLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'BioLab Monitor',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: background,
        primaryColor: Colors.blueAccent,
      ),
      home: const WelcomePage(),
    );
  }
}
