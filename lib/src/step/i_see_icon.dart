import 'package:bdd_widget_test/src/step/bdd_step.dart';

class ISeeIcon implements SurfBddStep {
  @override
  String get content => '''
Future<void> iSeeIcon(WidgetTester tester, IconData icon) async {
  expect(find.byIcon(icon), findsOneWidget);
}
''';

  @override
  List<String> get imports => ["import 'package:flutter_test/flutter_test.dart';"];
}
