import 'package:flutter/material.dart';

import '../models/echeance.dart';

// Écran 2 : détail d'une échéance
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.echeance});
  final Echeance echeance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail')),
      body: DetailContenu(echeance: echeance),
    );
  }
}

// Contenu réutilisé sur téléphone ET tablette
class DetailContenu extends StatefulWidget {
  const DetailContenu({super.key, required this.echeance, this.onChange});
  final Echeance echeance;
  final VoidCallback? onChange;

  @override
  State<DetailContenu> createState() => _DetailContenuState();
}

class _DetailContenuState extends State<DetailContenu> {
  @override
  Widget build(BuildContext context) {
    final e = widget.echeance;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.titre, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Matière : ${e.matiere}'),
                  Text('Pour le : ${formatDate.format(e.date)}'),
                  Text('Statut : ${e.fait ? "fait ✅" : "à faire"}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: e.fait
                ? null
                : () {
                    setState(() => e.fait = true);
                    widget.onChange?.call();
                  },
            icon: const Icon(Icons.check),
            label: const Text('Marquer comme fait'),
          ),
        ],
      ),
    );
  }
}
