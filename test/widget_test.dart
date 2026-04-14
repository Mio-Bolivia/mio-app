import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mio/main.dart';

void main() {
  testWidgets('MIO app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MIOApp()));

    await tester.pump();

    expect(find.text('MIO'), findsWidgets);
  });
}
