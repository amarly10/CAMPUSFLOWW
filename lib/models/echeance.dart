import 'package:intl/intl.dart';

final formatDate = DateFormat('dd/MM/yyyy');

class Echeance {
  Echeance(this.titre, this.matiere, this.date, {this.fait = false});

  final String titre;
  final String matiere;
  final DateTime date;
  bool fait;
}
