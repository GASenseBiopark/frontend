import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/pages/auth/log_in.dart';
import 'package:gasense/pages/auth/sign_up.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.white, background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 200),
              child: Image.asset(
                'assets/logo2.png',
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
              ),
            ),
            // Image.asset('../assets/logo.png', width: 120, height: 120),
            const SizedBox(height: 150),
            const Text(
              'Bem-vindo ao GASense!',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogInPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 150,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 135,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}
