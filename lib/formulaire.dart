import 'package:flutter/material.dart';

import 'main.dart';

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
      // Défilant + largeur max : lisible sur téléphone, tablette et paysage
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Remplis les informations du rendu.',
                      style: TextStyle(color: gris)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: titre,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Titre',
                      hintText: 'Ex. TP Flutter',
                      prefixIcon: Icon(Icons.edit_outlined),
                    ),
                    validator: obligatoire,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: matiere,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Matière',
                      hintText: 'Ex. Développement mobile',
                      prefixIcon: Icon(Icons.menu_book_outlined),
                    ),
                    validator: obligatoire,
                  ),
                  const SizedBox(height: 16),
                  // Champ date cliquable, même style que les autres champs
                  InkWell(
                    onTap: choisirDate,
                    borderRadius: BorderRadius.circular(16),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date limite',
                        prefixIcon: Icon(Icons.calendar_today_outlined, color: rouge),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      child: Text(formatDate.format(date)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: enregistrer,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Enregistrer'),
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
