import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/dao/dispositivo_dao.dart';
import 'package:gasense/models/dispositivo.dart';
import 'package:gasense/pages/navegation/home.dart';
import 'package:gasense/pages/navegation/tela_qr_code_scanner.dart';
import 'package:gasense/save_data/salvar_dados_dispositivos.dart';
import 'package:gasense/widgets/inputform.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

class NewDevicePage extends StatefulWidget {
  const NewDevicePage({super.key});

  @override
  State<NewDevicePage> createState() => _NewDevicePageState();
}

class _NewDevicePageState extends State<NewDevicePage> {
  final TextEditingController _codigoController = TextEditingController();
  bool _carregando = false;

  bool _deveMostrarCamera() {
    if (kIsWeb) {
      // Estamos na web
      return defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS;
    } else {
      // Estamos em plataforma nativa (Android ou iOS)
      return Platform.isAndroid || Platform.isIOS;
    }
  }

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

  void abrirLeitorQRCode() async {
    final codigoLido = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaQrCodeScanner()),
    );

    if (codigoLido != null) {
      _codigoController.text = codigoLido;
    }
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
        title: Text("Novo Dispositivo", style: AppText.titulo),
      ),
      body: Container(
        decoration: const BoxDecoration(
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;
                  double imageWidth;
                  if (screenWidth < 600) {
                    imageWidth = screenWidth * 0.8;
                  } else if (screenWidth < 1000) {
                    imageWidth = screenWidth * 0.5;
                  } else {
                    imageWidth = 400;
                  }
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Image.asset(
                            'assets/device.png',
                            width: imageWidth,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 50),
                        InputFormulario(
                          controller: _codigoController,
                          textoLabel: "Código",
                          icone: Icons.numbers,
                          sufixo:
                              _deveMostrarCamera()
                                  ? IconButton(
                                    icon: const Icon(
                                      Icons.qr_code_scanner,
                                      color: AppColors.grey,
                                    ),
                                    onPressed: abrirLeitorQRCode,
                                  )
                                  : null,
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
