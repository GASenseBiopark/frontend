import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/pages/auth/tela_carregamento.dart';
import 'package:gasense/pages/navegation/home.dart';
import 'package:gasense/widgets/inputform.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? emailError;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nomeController.text = prefs.getString('usuario_nome') ?? '';
      emailController.text = prefs.getString('usuario_email') ?? '';
    });
  }

  void _salvarAlteracoes() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('usuario_nome', nomeController.text);
      await prefs.setString('usuario_email', emailController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alterações salvas com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        backgroundColor: AppColors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.blue),
              child: Text(
                'Menu',
                style: AppText.titulo.copyWith(color: AppColors.white),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home_rounded,
                color: AppColors.black700,
              ),
              title: const Text(
                'Home',
                style: TextStyle(color: AppColors.black700),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings_rounded,
                color: AppColors.black700,
              ),
              title: const Text(
                'Configurações',
                style: TextStyle(color: AppColors.black700),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => UserPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: AppColors.black700,
              ),
              title: const Text(
                'Sair',
                style: TextStyle(color: AppColors.black700),
              ),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const TelaCarregamento(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder:
              (context) => InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => Scaffold.of(context).openDrawer(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.menu_rounded, color: AppColors.black700),
                ),
              ),
        ),
        title: Text("Configurações", style: AppText.titulo),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            transform: GradientRotation(1),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFECECEC)],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text("Editar Perfil", style: AppText.subtitulo),
                      const SizedBox(height: 20),
                      Text("Nome:", style: AppText.texto),
                      Text(
                        nomeController.text,
                        style: AppText.texto.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Email:", style: AppText.texto),
                      Text(
                        emailController.text,
                        style: AppText.texto.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      InputFormulario(
                        controller: nomeController,
                        textoLabel: "Alterar nome",
                        icone: Icons.person,
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
                      const SizedBox(height: 20),
                      InputFormulario(
                        controller: emailController,
                        textoLabel: "Alterar e-mail",
                        icone: Icons.email_rounded,
                        isEmail: true,
                        errorText: emailError,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Preencha o e-mail';
                          }
                          if (!value.contains("@") || !value.contains(".")) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _salvarAlteracoes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue100,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text("Salvar Alterações"),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const TelaCarregamento(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text("Sair da Conta"),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 193, 193, 193),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
