import 'package:flutter/material.dart';

import 'main.dart';
import 'formulaire.dart';


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

  /// À faire d'abord (par date), puis les tâches faites.
  List<Echeance> get triees => [...echeances]
    ..sort((a, b) {
      if (a.fait != b.fait) return a.fait ? 1 : -1;
      return a.date.compareTo(b.date);
    });

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

  Widget resume() {
    final faites = echeances.where((e) => e.fait).length;
    final total = echeances.length;
    final t = Theme.of(context).textTheme;
    return Card(
      color: vert,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ta progression',
                style: t.bodyMedium?.copyWith(color: Colors.white70)),
            const SizedBox(height: 4),
            Text('$faites / $total terminées',
                style: t.headlineSmall?.copyWith(color: Colors.white)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : faites / total,
                minHeight: 8,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget liste(bool large) {
    if (echeances.isEmpty) {
      return const EtatVide(
        icone: Icons.event_available,
        texte: 'Aucune échéance pour le moment.\nAppuie sur + pour en ajouter une.',
      );
    }
    final items = triees;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      itemCount: items.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        if (i == 0) return resume();
        final e = items[i - 1];
        final selectionne = large && e == selection;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: selectionne ? vert : const Color(0xFFE4E0E2),
              width: selectionne ? 2 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(4, 6, 16, 6),
            leading: IconButton(
              tooltip: e.fait ? 'Marquer à faire' : 'Marquer fait',
              icon: Icon(
                e.fait ? Icons.check_circle : Icons.radio_button_unchecked,
                color: e.fait ? vert : gris,
              ),
              onPressed: () => setState(() => e.fait = !e.fait),
            ),
            title: Text(
              e.titre,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: e.fait ? gris : encre,
                decoration: e.fait ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text('${e.matiere} · ${formatDate.format(e.date)}',
                  style: const TextStyle(color: gris)),
            ),
            trailing: BadgeUrgence(echeance: e),
            onTap: () => ouvrir(e, large),
          ),
        );
      },
    );
  }

  Widget profil() {
    final t = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 44,
            backgroundColor: vertClair,
            child: Icon(Icons.person, size: 48, color: vert),
          ),
          const SizedBox(height: 16),
          Text('Profil étudiant', style: t.headlineSmall),
          const SizedBox(height: 4),
          Text('${echeances.length} échéance(s) suivie(s)',
              style: const TextStyle(color: gris)),
        ],
      ),
    );
  }

  Widget contenu(bool large) {
    if (onglet == 1) return profil();
    if (!large) return liste(false);
    return Row(
      children: [
        SizedBox(width: 380, child: liste(true)),
        const VerticalDivider(width: 1),
        Expanded(
          child: selection == null
              ? const EtatVide(
                  icone: Icons.touch_app_outlined,
                  texte: 'Sélectionne une échéance',
                )
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
          appBar: AppBar(title: Text(onglet == 0 ? 'Mes échéances' : 'Profil')),
          body: large
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: onglet,
                      onDestinationSelected: (i) => setState(() => onglet = i),
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                            icon: Icon(Icons.event_outlined),
                            selectedIcon: Icon(Icons.event),
                            label: Text('Échéances')),
                        NavigationRailDestination(
                            icon: Icon(Icons.person_outline),
                            selectedIcon: Icon(Icons.person),
                            label: Text('Profil')),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: contenu(true)),
                  ],
                )
              : contenu(false),
          floatingActionButton: onglet == 0
              ? FloatingActionButton.extended(
                  onPressed: ajouter,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                )
              : null,
          bottomNavigationBar: large
              ? null
              : NavigationBar(
                  selectedIndex: onglet,
                  onDestinationSelected: (i) => setState(() => onglet = i),
                  destinations: const [
                    NavigationDestination(
                        icon: Icon(Icons.event_outlined),
                        selectedIcon: Icon(Icons.event),
                        label: 'Échéances'),
                    NavigationDestination(
                        icon: Icon(Icons.person_outline),
                        selectedIcon: Icon(Icons.person),
                        label: 'Profil'),
                  ],
                ),
        );
      },
    );
  }
}

// Message centré avec icône (liste vide, rien de sélectionné…)
class EtatVide extends StatelessWidget {
  const EtatVide({super.key, required this.icone, required this.texte});
  final IconData icone;
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 64, color: gris.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text(texte, textAlign: TextAlign.center, style: const TextStyle(color: gris)),
          ],
        ),
      ),
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
  void basculer() {
    setState(() => widget.echeance.fait = !widget.echeance.fait);
    widget.onChange?.call();
  }

  Widget ligne(IconData icone, String libelle, String valeur) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: vertClair,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icone, size: 20, color: vert),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(libelle, style: const TextStyle(color: gris, fontSize: 12)),
                Text(valeur, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(e.titre,
                                style: Theme.of(context).textTheme.headlineSmall),
                          ),
                          const SizedBox(width: 8),
                          BadgeUrgence(echeance: e),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      ligne(Icons.menu_book_outlined, 'Matière', e.matiere),
                      ligne(Icons.calendar_today_outlined, 'Pour le',
                          formatDate.format(e.date)),
                      ligne(e.fait ? Icons.check_circle_outline : Icons.pending_outlined,
                          'Statut', e.fait ? 'Fait' : 'À faire'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              e.fait
                  ? OutlinedButton.icon(
                      onPressed: basculer,
                      icon: const Icon(Icons.undo),
                      label: const Text('Remettre à faire'),
                    )
                  : FilledButton.icon(
                      onPressed: basculer,
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
