import 'package:flutter/material.dart';
import 'package:gasense/_core/constants.dart';
import 'package:gasense/colors/colors.dart';
import 'package:gasense/home.dart';
import 'package:gasense/pages/auth/sign_up.dart';
import 'package:gasense/widgets/inputform.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.white, background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo2.png', width: 150, height: 150),

            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(
                  children: [
                    const Text("Entrar", style: AppText.titulo),
                    const SizedBox(height: 20),
                    inputFormulario(
                      controller: emailController,
                      textoLabel: "Email",
                      icone: Icons.email,
                    ),
                    const SizedBox(height: 10),
                    inputFormulario(
                      controller: senhaController,
                      textoLabel: "Senha",
                      icone: Icons.lock,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Esqueceu a senha?",
                          style: AppText.textoPequeno,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.grey,
                            foregroundColor: Colors.white,
                            elevation: 6,
                            shadowColor: AppColors.blue.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Log in",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const Text("-OR-", style: AppText.textoPequeno),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              246,
                              255,
                              255,
                              255,
                            ),
                            foregroundColor: Colors.white,
                            elevation: 6,
                            shadowColor: AppColors.black.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google.png',
                                width: 22,
                                height: 22,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Entre com o Google",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text(
                        "Não tem uma conta? Se registre aqui!",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
