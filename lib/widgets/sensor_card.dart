import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';

Widget sensorCard(
  String nome,
  String sensor,
  int valor,
  int percent,
  Color cor,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 208, 208, 208),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          nome,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          sensor,
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
        const SizedBox(height: 12),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: percent / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(cor),
                strokeWidth: 8,
              ),
            ),
            Text(
              "$percent%",
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          "$valor ppm",
          style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
