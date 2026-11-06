import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'echeances.dart';

void main() => runApp(const CampusFlowApp());

// ================= THÈME (palette verte et rouge) =================
const vert = Color(0xFF2E7D32);
const vertClair = Color(0xFFE8F5E9);
const rouge = Color(0xFFB00020);
const rougeClair = Color(0xFFFDECEE);
const encre = Color(0xFF222222);
const gris = Color(0xFF6B6B6B);
const fond = Color(0xFFF3F1F2);

final _rayon = BorderRadius.circular(16);

final campusTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: vert,
    primary: vert,
    secondary: rouge,
    surface: fond,
    error: rouge,
  ),
  scaffoldBackgroundColor: fond,
  appBarTheme: const AppBarTheme(
    backgroundColor: fond,
    foregroundColor: encre,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
        fontSize: 22, fontWeight: FontWeight.bold, color: encre),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: _rayon,
      side: const BorderSide(color: Color(0xFFE4E0E2)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
        borderRadius: _rayon, borderSide: const BorderSide(color: Color(0xFFE4E0E2))),
    enabledBorder: OutlineInputBorder(
        borderRadius: _rayon, borderSide: const BorderSide(color: Color(0xFFE4E0E2))),
    focusedBorder: OutlineInputBorder(
        borderRadius: _rayon, borderSide: const BorderSide(color: vert, width: 2)),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(borderRadius: _rayon),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(borderRadius: _rayon),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: vert,
    foregroundColor: Colors.white,
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Colors.white,
    indicatorColor: vertClair,
  ),
  navigationRailTheme: const NavigationRailThemeData(
    backgroundColor: Colors.white,
    indicatorColor: vertClair,
  ),
  snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontWeight: FontWeight.bold, color: encre),
    headlineSmall: TextStyle(fontWeight: FontWeight.bold, color: encre),
    titleMedium: TextStyle(fontWeight: FontWeight.w600, color: encre),
    labelLarge: TextStyle(fontWeight: FontWeight.bold, color: vert, letterSpacing: 1.5),
    bodyMedium: TextStyle(color: encre),
  ),
);

// ================= MODÈLE =================
final formatDate = DateFormat('dd/MM/yyyy');

class Echeance {
  Echeance(this.titre, this.matiere, this.date, {this.fait = false});
  final String titre;
  final String matiere;
  final DateTime date;
  bool fait;

  /// Nombre de jours avant l'échéance (négatif si dépassée).
  int get joursRestants {
    final now = DateTime.now();
    final aujourdhui = DateTime(now.year, now.month, now.day);
    return DateTime(date.year, date.month, date.day).difference(aujourdhui).inDays;
  }
}

// ================= APPLICATION =================
class CampusFlowApp extends StatelessWidget {
  const CampusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusFlow',
      debugShowCheckedModeBanner: false,
      theme: campusTheme,
      home: const TitreScreen(),
    );
  }
}

// ================= ÉCRAN DE TITRE =================
class TitreScreen extends StatelessWidget {
  const TitreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          // Défilant : pas de débordement en paysage
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  Text('ATELIER · CAMPUSFLOW', style: t.labelLarge),
                  const SizedBox(height: 8),
                  Text('CampusFlow', style: t.headlineLarge),
                  const SizedBox(height: 12),
                  Text(
                    'Toutes tes échéances au même endroit.\nNe rate plus aucun rendu.',
                    textAlign: TextAlign.center,
                    style: t.bodyLarge?.copyWith(color: gris, height: 1.4),
                  ),
                  const SizedBox(height: 40),
                  FilledButton.icon(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const EcheancesScreen()),
                    ),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Commencer'),
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

// ================= WIDGETS PARTAGÉS =================

/// Petite pastille indiquant l'urgence d'une échéance (J-3, Aujourd'hui, En retard…).
class BadgeUrgence extends StatelessWidget {
  const BadgeUrgence({super.key, required this.echeance});
  final Echeance echeance;

  @override
  Widget build(BuildContext context) {
    final j = echeance.joursRestants;
    final (String texte, Color couleur, Color fondBadge) = echeance.fait
        ? ('Fait', vert, vertClair)
        : j < 0
            ? ('En retard', Colors.white, rouge)
            : j == 0
                ? ("Aujourd'hui", rouge, rougeClair)
                : j <= 3
                    ? ('J-$j', rouge, rougeClair)
                    : ('J-$j', vert, vertClair);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fondBadge,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        texte,
        style: TextStyle(color: couleur, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
