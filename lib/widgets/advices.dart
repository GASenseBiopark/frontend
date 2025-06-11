// import 'package:flutter/material.dart';
// import 'package:gasense/_core/constants.dart';

// Widget advices({
//   required TextEditingController controller,
//   required String textoLabel,
//   IconData icone = Icons.email,
//   bool obscureText = false,
// }) {
// return

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Adicionar Dispositivo"),
//           content: Column(
//             children: [
//               TextField(
//                 autofocus: true,
//                 decoration: const InputDecoration(
//                   labelText: "Nome do dispositivo",
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (value) {
//                   novoDispositivo = value;
//                 },
//               ),
//               TextField(
//                 autofocus: true,
//                 decoration: const InputDecoration(
//                   labelText: "Código",
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (value) {
//                   codigo = 0;
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               child: const Text("Cancelar"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Adicionar"),
//               onPressed: () {
//                 if (novoDispositivo.isNotEmpty) {
//                   setState(() {
//                     dispositivos.add(novoDispositivo);
//                   });
//                   Navigator.of(context).pop();
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
