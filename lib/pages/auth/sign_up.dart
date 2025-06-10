import 'package:flutter/material.dart';
import 'package:gasense/_core/constants.dart';
import 'package:gasense/colors/colors.dart';
import 'package:gasense/pages/auth/log_in.dart';
import 'package:gasense/widgets/inputform.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 200),
              child: Image.asset(
                'assets/logo2.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.75,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(color: AppColors.white),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text("Criar uma conta", style: AppText.titulo),
                        const SizedBox(height: 20),
                        inputFormulario(
                          controller: emailController,
                          textoLabel: "Nome",
                          icone: Icons.person_2,
                        ),
                        const SizedBox(height: 10),
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => const TelaLogIn()),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.grey,
                                foregroundColor: const Color.fromARGB(
                                  53,
                                  255,
                                  255,
                                  255,
                                ),
                                elevation: 6,
                                shadowColor: AppColors.blue.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                "Log in",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "-OR-",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => const HomePage()),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  255,
                                  255,
                                  255,
                                ),
                                foregroundColor: AppColors.blue,
                                elevation: 6,
                                shadowColor: Colors.black.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/google.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    "Entre com o Google",
                                    style: TextStyle(
                                      fontSize: 16,
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
                              MaterialPageRoute(
                                builder: (context) => LogInPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Já tem uma conta? Entre aqui!",
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
