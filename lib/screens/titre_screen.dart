import 'package:flutter/material.dart';

import '../theme.dart';
import 'echeances_screen.dart';

class TitreScreen extends StatelessWidget {
  const TitreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 120,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.school, size: 120, color: rouge),
              ),
              const SizedBox(height: 24),
              Text('ATELIER · CAMPUSFLOW', style: t.labelLarge),
              Text('CampusFlow', style: t.headlineLarge),
              const SizedBox(height: 8),
              const Text('Toutes tes échéances au même endroit.'),
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
    );
  }
}
