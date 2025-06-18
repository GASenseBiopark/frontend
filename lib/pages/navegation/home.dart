import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/models/dispositivo.dart';
import 'package:gasense/pages/auth/welcome.dart';
import 'package:gasense/pages/navegation/new_device.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> dispositivos = [];

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
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Image.asset(
                            'assets/device.png',
                            width: 50,
                            height: 22,
                          ),
                          title: Text(item['nome'] ?? 'Sem nome'),
                          subtitle: Text(
                            "Código: ${item['codigo'] ?? 'Sem código'}",
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
