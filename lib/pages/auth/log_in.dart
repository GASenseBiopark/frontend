import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/pages/navegation/home.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 800;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isDesktop) const SizedBox(height: 60),
        Text(
          "Acesse sua conta",
          style: AppText.titulo.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Monitore a segurança do seu laboratório em tempo real",
          textAlign: TextAlign.center,
          style: AppText.textoPequeno.copyWith(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 40),
        inputFormulario(
          controller: emailController,
          textoLabel: "Email",
          icone: Icons.email,
        ),
        const SizedBox(height: 16),
        inputFormulario(
          controller: senhaController,
          textoLabel: "Senha",
          icone: Icons.lock,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text("Esqueceu a senha?", style: AppText.textoPequeno),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.grey,
              foregroundColor: Colors.white,
              elevation: 6,
              shadowColor: AppColors.blue.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text("Entrar", style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.grey)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("OU", style: AppText.textoPequeno),
            ),
            Expanded(child: Divider(color: AppColors.grey)),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(246, 255, 255, 255),
              elevation: 6,
              shadowColor: AppColors.black.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/google.png', width: 22, height: 22),
                const SizedBox(width: 12),
                const Text(
                  "Entrar com o Google",
                  style: TextStyle(fontSize: 14, color: AppColors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignUpPage()),
            );
          },
          child: const Text(
            "Não tem uma conta? Registre-se aqui!",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ],
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFECECEC)],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child:
                isDesktop
                    ? Container(
                      width: 500,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(36),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: content,
                    )
                    : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: content,
                    ),
          ),
        ),
      ),
    );
  }
}
