import 'package:bdd_widget_test/src/step/bdd_step.dart';

class ISeeText implements SurfBddStep {
  @override
  String get content => '''
Future<void> iSeeText(WidgetTester tester, String text) async {
  expect(find.text(text), findsOneWidget);
}
''';

  @override
  List<String> get imports => [
    "import 'package:flutter_test/flutter_test.dart';",
  ];
}
