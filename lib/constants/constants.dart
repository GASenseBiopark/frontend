import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color black = Color(0xFF000000);
  static const Color black700 = Color(0xFF23272A);
  static const Color blue = Color(0xFF45484D);
  static const Color grey = Color(0xFF767676);
  static const Color grey200 = Color(0xFF9B9B9B);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
}

Color background = const Color.fromARGB(255, 46, 57, 87);

abstract class AppText {
  static const TextStyle titulo = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30,
    color: AppColors.blue,
  );
  static const TextStyle texto = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.black,
  );
  static const TextStyle textoPequeno = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.grey,
  );
}
