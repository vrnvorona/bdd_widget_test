import 'package:bdd_widget_test/src/step/bdd_step.dart';

class IDontSeeIcon implements SurfBddStep {
  @override
  String get content => '''
Future<void> iDontSeeIcon(WidgetTester tester, IconData icon) async {
  expect(find.byIcon(icon), findsNothing);
}
''';

  @override
  List<String> get imports => ["import 'package:flutter_test/flutter_test.dart';"];
}
