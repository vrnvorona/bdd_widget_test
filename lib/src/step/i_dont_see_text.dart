import 'package:bdd_widget_test/src/step/bdd_step.dart';

class IDontSeeText implements SurfBddStep {
  @override
  String get content => '''
Future<void> iDontSeeText(WidgetTester tester, String text) async {
  expect(find.text(text), findsNothing);
}
''';

  @override
  List<String> get imports => ["import 'package:flutter_test/flutter_test.dart';"];
}
