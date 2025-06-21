import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/models/dispositivo.dart';
import 'package:gasense/pages/auth/tela_carregamento.dart';
import 'package:gasense/pages/navegation/tela_graficos.dart';
import 'package:gasense/pages/navegation/tela_novo_dispositivo.dart';
import 'package:gasense/save_data/salvar_dados_dispositivos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Dispositivo> dispositivos = [];

  @override
  void initState() {
    super.initState();
    _loadDispositivos();
  }

  void _loadDispositivos() async {
    final lista = await carregarDispositivos();

    setState(() {
      dispositivos = lista;
    });
  }

  void _navegarParaAdicionarDispositivo() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewDevicePage()),
    );

    if (resultado != null && resultado is Dispositivo) {
      await salvarDispositivo(resultado);
      _loadDispositivos(); // recarrega a lista com o novo dispositivo salvo
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
                  MaterialPageRoute(
                    builder: (context) => const TelaCarregamento(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: AppColors.black700),
              title: Text(
                'Configurações',
                style: TextStyle(color: AppColors.black700),
              ),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const UserPage()),
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
                      final Dispositivo dispositivo = dispositivos[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            splashColor: AppColors.grey200.withAlpha(72),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => TelaGraficos(
                                        dispositivo: dispositivo,
                                      ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withAlpha(
                                                  80,
                                                ),
                                                blurRadius: 50,
                                                offset: Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 30,
                                            left: 30,
                                          ),
                                          child: Image.asset(
                                            'assets/device.PNG',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      dispositivo.nome,
                                      style: AppText.titulo.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Código: ${dispositivo.idDispositivo}",
                                      style: AppText.textoPequeno.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
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
