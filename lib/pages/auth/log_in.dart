import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/dao/usuario_dao.dart';
import 'package:gasense/pages/navegation/home.dart';
import 'package:gasense/pages/auth/sign_up.dart';
import 'package:gasense/save_data/salvar_dados_usuarios.dart';
import 'package:gasense/widgets/inputform.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final UsuarioDAO usuarioDAO = UsuarioDAO();

  String? emailError;
  String? senhaError;
  bool _isLoading = false;

  Future<void> realizarLogin() async {
    setState(() {
      emailError = null;
      senhaError = null;
      _isLoading = true;
    });

    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    try {
      final usuario = await usuarioDAO.pesquisar(email, senha);

      if (usuario == null) {
        setState(() {
          emailError = '';
          senhaError = 'E-mail ou senha inválidos!';
        });
        return;
      }

      await salvarDadosUsuario(usuario);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao realizar login: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 800;

    Widget content = Form(
      key: _formKey,
      child: Column(
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
          InputFormulario(
            controller: emailController,
            textoLabel: "E-mail",
            icone: Icons.email_rounded,
            isEmail: true,
            errorText: emailError,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Preencha o e-mail';
              }
              if (!value.contains(".") || !value.contains('@')) {
                return 'E-mail inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          InputFormulario(
            controller: senhaController,
            textoLabel: "Senha",
            icone: Icons.lock_rounded,
            isSenha: true,
            errorText: senhaError,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Preencha a senha';
              }
              if (value.length < 8) {
                return 'Senha deve ter no mínimo 8 caracteres';
              }
              return null;
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {}, // Implementar futuramente reset de senha
              child: Text("Esqueceu a senha?", style: AppText.textoPequeno),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && !_isLoading) {
                  realizarLogin();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.grey,
                foregroundColor: Colors.white,
                elevation: 6,
                shadowColor: AppColors.blue.withValues(alpha: 0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child:
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Entrar", style: TextStyle(fontSize: 16)),
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
                shadowColor: AppColors.black.withValues(alpha: 0.8),
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
      ),
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
