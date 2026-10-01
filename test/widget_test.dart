import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cce_mains_revision/providers/app_state_provider.dart';
import 'package:cce_mains_revision/main.dart';

void main() {
  testWidgets('App smoke test loads CCE mains revision app', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ],
        child: const CceMainsApp(),
      ),
    );

    // Verify title loads
    expect(find.text('GSSSB CCE મુખ્ય પરીક્ષા (ગ્રુપ B)'), findsOneWidget);
  });
}
