import 'package:flutter/material.dart';

import 'main.dart';
import 'formulaire.dart';

// ================= 1. ÉCRAN ÉCHÉANCES (+ 4. TABLETTE) =================
// Téléphone (< 840 dp) : liste + NavigationBar en bas, détail sur un nouvel écran
// Tablette  (≥ 840 dp) : NavigationRail à gauche, liste et détail côte à côte
class EcheancesScreen extends StatefulWidget {
  const EcheancesScreen({super.key});

  @override
  State<EcheancesScreen> createState() => _EcheancesScreenState();
}

class _EcheancesScreenState extends State<EcheancesScreen> {
  final echeances = <Echeance>[
    Echeance('TP Flutter', 'Développement mobile', DateTime(2026, 11, 12)),
    Echeance('Exposé réseaux', 'Réseaux', DateTime(2026, 11, 15)),
    Echeance('Devoir de maths', 'Mathématiques', DateTime(2026, 11, 20)),
  ];
  Echeance? selection;
  int onglet = 0;

  Future<void> ouvrir(Echeance e, bool large) async {
    if (large) {
      setState(() => selection = e);
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(echeance: e)),
    );
    setState(() {});
  }

  Future<void> ajouter() async {
    final nouvelle = await Navigator.push<Echeance>(
      context,
      MaterialPageRoute(builder: (_) => const FormulaireScreen()),
    );
    if (nouvelle != null) setState(() => echeances.add(nouvelle));
  }

  Widget liste(bool large) {
    return ListView.builder(
      itemCount: echeances.length,
      itemBuilder: (context, i) {
        final e = echeances[i];
        return ListTile(
          leading: Icon(
            e.fait ? Icons.check_circle : Icons.radio_button_unchecked,
            color: rouge,
          ),
          title: Text(
            e.titre,
            style: TextStyle(decoration: e.fait ? TextDecoration.lineThrough : null),
          ),
          subtitle: Text('${e.matiere} · ${formatDate.format(e.date)}'),
          trailing: const Icon(Icons.chevron_right),
          selected: large && e == selection,
          onTap: () => ouvrir(e, large),
        );
      },
    );
  }

  Widget contenu(bool large) {
    if (onglet == 1) return const Center(child: Text('Profil étudiant'));
    if (!large) return liste(false);
    return Row(
      children: [
        SizedBox(width: 360, child: liste(true)),
        const VerticalDivider(width: 1),
        Expanded(
          child: selection == null
              ? const Center(child: Text('Sélectionne une échéance'))
              : DetailContenu(echeance: selection!, onChange: () => setState(() {})),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final large = constraints.maxWidth >= 840;

        return Scaffold(
          appBar: AppBar(title: Text(onglet == 0 ? 'Échéances' : 'Profil')),
          body: large
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: onglet,
                      onDestinationSelected: (i) => setState(() => onglet = i),
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                            icon: Icon(Icons.event), label: Text('Échéances')),
                        NavigationRailDestination(
                            icon: Icon(Icons.person), label: Text('Profil')),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: contenu(true)),
                  ],
                )
              : contenu(false),
          floatingActionButton: onglet == 0
              ? FloatingActionButton(onPressed: ajouter, child: const Icon(Icons.add))
              : null,
          bottomNavigationBar: large
              ? null
              : NavigationBar(
                  selectedIndex: onglet,
                  onDestinationSelected: (i) => setState(() => onglet = i),
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.event), label: 'Échéances'),
                    NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
                  ],
                ),
        );
      },
    );
  }
}

// ================= 2. ÉCRAN DÉTAIL =================
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

// Contenu du détail, réutilisé sur téléphone ET tablette
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
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
        ),
      ),
    );
  }
}
