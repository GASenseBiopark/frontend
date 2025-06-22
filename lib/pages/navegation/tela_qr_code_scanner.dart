import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TelaQrCodeScanner extends StatefulWidget {
  @override
  _TelaQrCodeScannerState createState() => _TelaQrCodeScannerState();
}

class _TelaQrCodeScannerState extends State<TelaQrCodeScanner> {
  late MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onDetect(Barcode barcode) {
    if (barcode.rawValue != null) {
      String codigoLido = barcode.rawValue!;
      controller.dispose();
      Navigator.pop(context, codigoLido);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Leitor de QR Code')),
      body: MobileScanner(
        controller: controller,
        onDetect: (BarcodeCapture barcodeCapture) {
          final barcode = barcodeCapture.barcodes.first;
          onDetect(barcode);
        },
      ),
    );
  }
}