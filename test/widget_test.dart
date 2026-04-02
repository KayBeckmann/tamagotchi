import 'package:flutter_test/flutter_test.dart';
import 'package:tamagotchi/main.dart';

void main() {
  testWidgets('App starts without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const TamagotchiApp());
    await tester.pumpAndSettle();

    expect(find.text('Anmelden'), findsOneWidget);
  });
}
