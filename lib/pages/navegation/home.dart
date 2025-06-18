import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/models/dispositivo.dart';
import 'package:gasense/pages/auth/welcome.dart';
import 'package:gasense/pages/navegation/tela_graficos.dart';
import 'package:gasense/pages/navegation/tela_novo_dispositivo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> dispositivos = [];

  @override
  void initState() {
    super.initState();
    _loadDispositivos();
  }

  void _loadDispositivos() async {
    final prefs = await SharedPreferences.getInstance();
    final listaCodigos = prefs.getStringList('dispositivos') ?? [];

    setState(() {
      dispositivos = listaCodigos.map((e) => {'codigo': e, 'nome': e}).toList();
    });
  }

  void _navegarParaAdicionarDispositivo() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewDevicePage()),
    );

    if (resultado != null && resultado is Dispositivo) {
      setState(() {
        dispositivos.add({
          'codigo': resultado.idDispositivo,
          'nome': resultado.nome,
        });
      });
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
              decoration: BoxDecoration(color: AppColors.blue100),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout_rounded, color: AppColors.black700),
              title: Text('Sair', style: TextStyle(color: AppColors.black700)),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false, // você controla o leading
        leading: Builder(
          builder: (context) {
            return InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.menu_rounded, color: AppColors.black700),
              ),
            );
          },
        ),
        title: Text(
          "Dispositivos",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.black700,
          ),
        ),
      ),
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
        child: Padding(
          padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top,
          ),
          child:
              dispositivos.isEmpty
                  ? Center(
                    child: Text(
                      'Nenhum dispositivo adicionado',
                      style: AppText.texto,
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: dispositivos.length,
                    itemBuilder: (context, index) {
                      final item = dispositivos[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(36),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color:
                              Colors
                                  .transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            splashColor: AppColors.grey200.withAlpha(
                              72,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TelaGraficos(
                                    // idDispositivo: item['codigo'],
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              leading: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(80),
                                          blurRadius: 15,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    '../assets/device.png',
                                    fit: BoxFit.contain,
                                    width: 60,
                                  ),
                                ],
                              ),
                              title: Text(
                                item['nome'] ?? 'Sem nome',
                                style: AppText.titulo.copyWith(
                                  fontSize: 16,
                                  color: AppColors.black700,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "Código: ${item['codigo'] ?? 'Sem código'}",
                                  style: AppText.textoPequeno.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarParaAdicionarDispositivo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
