import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  // Estilo principal usando Raleway
  static TextStyle ralewayStyle = GoogleFonts.raleway();

  // Estilos de encabezado usando Lato
  static TextStyle headline1 = GoogleFonts.lato(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle headline2 = GoogleFonts.lato(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  // Estilos de subtítulos usando Open Sans
  static TextStyle subtitle1 = GoogleFonts.openSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black54,
  );

  static TextStyle subtitle2 = GoogleFonts.openSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );

  // Estilos de cuerpo de texto usando Roboto
  static TextStyle bodyText1 = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static TextStyle bodyText2 = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );

  // Estilo para botones usando Raleway
  static TextStyle buttonText = GoogleFonts.raleway(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Estilo para etiquetas o "chips" usando Roboto Condensed
  static TextStyle chipText = GoogleFonts.robotoCondensed(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  // Estilo de entrada de texto (input) usando Raleway
  static TextStyle inputText = GoogleFonts.raleway(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  // Estilo para mensajes de error usando Montserrat
  static TextStyle errorText = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.redAccent,
  );
}
