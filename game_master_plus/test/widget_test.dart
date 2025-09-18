import 'package:flutter_test/flutter_test.dart';

import 'package:game_master_plus/main.dart';

void main() {
  testWidgets('renders main navigation tabs', (tester) async {
    await tester.pumpWidget(const GameMasterPlusApp());
    await tester.pumpAndSettle();

    expect(find.text('Game Master Plus'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.text('Automação'), findsOneWidget);
  });
}
