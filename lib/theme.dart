import 'package:flutter/material.dart';

// Couleurs du design system (séance 2)
const rouge = Color(0xFFE8341C);
const encre = Color(0xFF222222);
const fond = Color(0xFFF3F1F2);

final campusTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: rouge, primary: rouge, surface: fond),
  scaffoldBackgroundColor: fond,
  appBarTheme: const AppBarTheme(backgroundColor: fond, foregroundColor: encre),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontWeight: FontWeight.bold, color: encre),
    headlineSmall: TextStyle(fontWeight: FontWeight.bold, color: encre),
    labelLarge: TextStyle(fontWeight: FontWeight.bold, color: rouge, letterSpacing: 1.5),
    bodyMedium: TextStyle(color: encre),
  ),
);
