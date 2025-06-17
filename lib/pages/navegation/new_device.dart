import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/pages/navegation/home.dart';
import 'package:gasense/widgets/inputform.dart';

class NewDevicePage extends StatefulWidget {
  const NewDevicePage({super.key});

  @override
  State<NewDevicePage> createState() => _NewDevicePageState();
}

class _NewDevicePageState extends State<NewDevicePage> {
  final TextEditingController _codigoController = TextEditingController();

  void _adicionarDispositivo() {
    final codigo = _codigoController.text.trim();

    if (codigo.isNotEmpty) {
      Navigator.pop(context, {'codigo': codigo});
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
                      // Sombra (menor que a imagem)
                      Container(
                        width: 270, // menor que 200
                        height: 270, // menor que 200
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

                      // Imagem principal
                      Image.asset('../assets/device.png', width: 350),
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
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        final codigo = _codigoController.text.trim();
                        if (codigo.isNotEmpty) {
                          Navigator.pop(context, {'codigo': codigo});
                        }
                      },
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
                      child: Text(
                        "Adicionar dispositivo",
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
