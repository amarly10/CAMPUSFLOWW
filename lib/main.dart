import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // package ajouté avec : flutter pub add intl

void main() => runApp(const CampusFlowApp());

// ================= THÈME (design system séance 2) =================
const rouge = Color(0xFFE8341C);
const encre = Color(0xFF222222);
const fond = Color(0xFFF3F1F2);

final theme = ThemeData(
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

final formatDate = DateFormat('dd/MM/yyyy');

class CampusFlowApp extends StatelessWidget {
  const CampusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusFlow',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const TitreScreen(),
    );
  }
}

// ================= MODÈLE =================
class Echeance {
  Echeance(this.titre, this.matiere, this.date, {this.fait = false});
  final String titre;
  final String matiere;
  final DateTime date;
  bool fait;
}

// ================= ÉCRAN DE TITRE (atelier 1) =================
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

// ================= 1. ÉCRAN ÉCHÉANCES + 4. TABLETTE =================
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(onglet == 0 ? 'Échéances' : 'Profil')),
      body: onglet == 1
          ? const Center(child: Text('Profil étudiant'))
          : LayoutBuilder(
              builder: (context, constraints) {
                final large = constraints.maxWidth >= 840;

                final liste = ListView.builder(
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

                if (!large) return liste; // téléphone

                // Tablette : liste et détail côte à côte
                return Row(
                  children: [
                    SizedBox(width: 360, child: liste),
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

// ================= 3. FORMULAIRE =================
class FormulaireScreen extends StatefulWidget {
  const FormulaireScreen({super.key});

  @override
  State<FormulaireScreen> createState() => _FormulaireScreenState();
}

class _FormulaireScreenState extends State<FormulaireScreen> {
  final formKey = GlobalKey<FormState>();
  final titre = TextEditingController();
  final matiere = TextEditingController();
  DateTime date = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    titre.dispose();
    matiere.dispose();
    super.dispose();
  }

  String? obligatoire(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null;

  Future<void> choisirDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (d != null) setState(() => date = d);
  }

  void enregistrer() {
    if (!formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Échéance ajoutée')),
    );
    Navigator.pop(context, Echeance(titre.text.trim(), matiere.text.trim(), date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle échéance')),
      body: SingleChildScrollView( // défilant
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titre,
                decoration: const InputDecoration(
                    labelText: 'Titre', border: OutlineInputBorder()),
                validator: obligatoire,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: matiere,
                decoration: const InputDecoration(
                    labelText: 'Matière', border: OutlineInputBorder()),
                validator: obligatoire,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today, color: rouge),
                title: Text('Date : ${formatDate.format(date)}'),
                trailing: TextButton(onPressed: choisirDate, child: const Text('Changer')),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: enregistrer, child: const Text('Enregistrer')),
            ],
          ),
        ),
      ),
    );
  }
}
