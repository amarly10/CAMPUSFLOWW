import 'package:flutter/material.dart';

import '../models/echeance.dart';
import '../theme.dart';

// Écran 3 : formulaire d'ajout
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
