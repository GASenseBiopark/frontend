import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const Color black = Color(0xFF000000);
  static const Color black700 = Color.fromARGB(255, 64, 64, 64);
  static const Color blue100 = Color.fromARGB(255, 88, 88, 88);
  static const Color blue = Color.fromARGB(255, 32, 59, 102);
  static const Color grey = Color(0xFF767676);
  static const Color grey200 = Color(0xFF9B9B9B);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color green = Colors.green;
  static const Color orange = Colors.orange;
  static const Color red = Colors.red;
  static const Color lightblue = Colors.blue;
}

Color background = const Color.fromARGB(255, 46, 57, 87);

abstract class AppText {
  static TextStyle titulo = GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 30,
    color: AppColors.blue,
  );
  static TextStyle subtitulo = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 24,
    color: AppColors.black700,
  );
  static TextStyle textoGrande = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.black,
  );
  static TextStyle texto = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.black,
  );
  static TextStyle textoBranco = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.white,
  );
  static TextStyle textoPequeno = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.grey,
  );
}
