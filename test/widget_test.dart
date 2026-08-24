import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rudra_officer/app.dart';

void main() {
  testWidgets('RUDRA Officer app builds', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(MyApp), findsOneWidget);
  });
}
