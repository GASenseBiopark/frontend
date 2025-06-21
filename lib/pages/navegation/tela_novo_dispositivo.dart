import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/dao/dispositivo_dao.dart';
import 'package:gasense/models/dispositivo.dart';
import 'package:gasense/pages/navegation/home.dart';
import 'package:gasense/save_data/salvar_dados_dispositivos.dart';
import 'package:gasense/widgets/inputform.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewDevicePage extends StatefulWidget {
  const NewDevicePage({super.key});

  @override
  State<NewDevicePage> createState() => _NewDevicePageState();
}

class _NewDevicePageState extends State<NewDevicePage> {
  final TextEditingController _codigoController = TextEditingController();
  bool _carregando = false;

  void buscarDispositivo() async {
    final codigo = _codigoController.text.trim();
    if (codigo.isEmpty) {
      _mostrarMensagem('Digite um código');
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      // verifica se já existe no armazenamento
      if (prefs.containsKey('dispositivo_$codigo')) {
        _mostrarMensagem('Dispositivo já adicionado!');
        setState(() {
          _carregando = false;
        });
        return;
      }

      Dispositivo dispositivo = await DispositivoDAO().buscarDispositoPorId(
        codigo,
      );

      salvarDispositivo(dispositivo);

      // Retorna o dispositivo completo para a tela anterior
      Navigator.pop(context, dispositivo);
    } catch (e) {
      _mostrarMensagem(e.toString());
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.black700),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: const Text(
          "Novo Dispositivo",
          style: TextStyle(color: AppColors.black700, fontSize: 22),
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 270,
                        height: 270,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(50),
                              blurRadius: 40,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                      ),
                      Image.asset('assets/device.PNG', width: 350),
                    ],
                  ),
                  const SizedBox(height: 50),
                  InputFormulario(
                    controller: _codigoController,
                    textoLabel: "Código",
                    icone: Icons.numbers,
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: _carregando ? null : buscarDispositivo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child:
                          _carregando
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Text(
                                "Buscar dispositivo",
                                style: AppText.textoBranco,
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
