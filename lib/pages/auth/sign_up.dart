import 'package:flutter/material.dart';
import 'package:gasense/dao/usuario_dao.dart';
import 'package:gasense/models/usuario.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/pages/navegation/home.dart';
import 'package:gasense/pages/auth/log_in.dart';
import 'package:gasense/widgets/inputform.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _emailErroServidor;

  bool _isLoading = false;

  Future<void> registrarUsuario() async {
    setState(() {
      _isLoading = true;
      _emailErroServidor = null;
    });

    try {
      Usuario usuario = Usuario(
        idUsuario: 0, // ou null, depende do seu modelo
        nome: nomeController.text,
        email: emailController.text,
        senhaHash: senhaController.text, // senha pura, o backend faz o hash
        dataCadastro: DateTime.now().toIso8601String(),
      );

      UsuarioDAO dao = UsuarioDAO();
      int idGerado = await dao.adicionarEditar(usuario);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Usuário registrado com sucesso! ID: $idGerado"),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      String mensagem = e.toString();
      if (mensagem.contains('E-mail já cadastrado')) {
        setState(() {
          _emailErroServidor = 'Este email já está em uso.';
        });
        // Força o validator a rodar de novo:
        _formKey.currentState!.validate();
      } else {
        // Erro genérico
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro ao registrar: $mensagem")));
      }
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
            "Criar uma conta",
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
            controller: nomeController,
            textoLabel: "Nome",
            icone: Icons.person_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Preencha o nome';
              }
              if (value.length < 5) {
                return 'Nome deve ter no mínimo 5 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          InputFormulario(
            controller: emailController,
            textoLabel: "Email",
            icone: Icons.email_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Preencha o e-mail';
              }
              if (!value.contains(".")) {
                return 'E-mail inválido';
              }
              if (!value.contains('@')) {
                return 'E-mail inválido';
              }
              if (_emailErroServidor != null) {
                return _emailErroServidor;
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
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (!_isLoading) {
                    registrarUsuario();
                  }
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
                      : const Text("Registrar", style: TextStyle(fontSize: 16)),
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
                MaterialPageRoute(builder: (context) => const LogInPage()),
              );
            },
            child: const Text(
              "Já tem uma conta? Entre aqui!",
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
