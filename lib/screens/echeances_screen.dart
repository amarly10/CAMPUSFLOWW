import 'package:flutter/material.dart';

import '../models/echeance.dart';
import '../theme.dart';
import 'detail_screen.dart';
import 'formulaire_screen.dart';

// Écran 1 : liste des échéances + Écran 4 : version tablette (≥ 840 dp)
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
  Echeance? selection; // utilisé en mode tablette
  int onglet = 0;

  Future<void> ouvrir(Echeance e, bool large) async {
    if (large) {
      setState(() => selection = e); // tablette : détail à droite
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(echeance: e)),
    );
    setState(() {}); // rafraîchit si "fait" a changé
  }

  Future<void> ajouter() async {
    final nouvelle = await Navigator.push<Echeance>(
      context,
      MaterialPageRoute(builder: (_) => const FormulaireScreen()),
    );
    if (nouvelle != null) setState(() => echeances.add(nouvelle));
  }

  Widget construireListe(bool large) {
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
            style: TextStyle(
              decoration: e.fait ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text('${e.matiere} · ${formatDate.format(e.date)}'),
          trailing: const Icon(Icons.chevron_right),
          selected: large && e == selection,
          onTap: () => ouvrir(e, large),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(onglet == 0 ? 'Échéances' : 'Profil')),
      body: onglet == 1
          ? const Center(child: Text('Profil étudiant'))
          : LayoutBuilder(
              builder: (context, constraints) {
                final large = constraints.maxWidth >= 840;
                if (!large) return construireListe(false); // téléphone

                // Tablette : liste et détail côte à côte
                return Row(
                  children: [
                    SizedBox(width: 360, child: construireListe(true)),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: selection == null
                          ? const Center(child: Text('Sélectionne une échéance'))
                          : DetailContenu(
                              echeance: selection!,
                              onChange: () => setState(() {}),
                            ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: onglet == 0
          ? FloatingActionButton(onPressed: ajouter, child: const Icon(Icons.add))
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: onglet,
        onDestinationSelected: (i) => setState(() => onglet = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.event), label: 'Échéances'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
