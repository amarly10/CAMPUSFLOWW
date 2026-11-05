import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'echeances.dart';

void main() => runApp(const CampusFlowApp());

// ================= THÈME (design system séance 2) =================
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

// ================= MODÈLE =================
final formatDate = DateFormat('dd/MM/yyyy');

class Echeance {
  Echeance(this.titre, this.matiere, this.date, {this.fait = false});
  final String titre;
  final String matiere;
  final DateTime date;
  bool fait;
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
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png', width: 120),
                  const SizedBox(height: 24),
                  Text('ATELIER · CAMPUSFLOW', style: t.labelLarge),
                  Text('CampusFlow', style: t.headlineLarge),
                  const SizedBox(height: 8),
                  const Text('Toutes tes échéances au même endroit.',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const EcheancesScreen()),
                    ),
                    child: const Text('Commencer'),
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
