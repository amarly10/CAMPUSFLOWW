import 'package:flutter_test/flutter_test.dart';
import 'package:campusflow/main.dart';

void main() {
  testWidgets('L\'écran de titre s\'affiche', (tester) async {
    await tester.pumpWidget(const CampusFlowApp());
    expect(find.text('CampusFlow'), findsOneWidget);
    expect(find.text('Commencer'), findsOneWidget);
  });
}
