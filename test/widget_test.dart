import 'package:flutter_test/flutter_test.dart';
import 'package:untitled001/main.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MonitorKoperApp());
    expect(find.text('Monitoring Koper CCTV'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });
}
