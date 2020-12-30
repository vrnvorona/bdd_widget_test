import 'package:bdd_widget_test/src/step/bdd_step.dart';

class ITapIconAndWait implements SurfBddStep {
  @override
  String get content => '''
Future<void> iTapIconAndWait(WidgetTester tester, IconData icon) async {
  await tester.tap(find.byIcon(icon));
  await tester.pumpAndSettle();
}
''';

  @override
  List<String> get imports => [
    "import 'package:flutter/widgets.dart';",
    "import 'package:flutter_test/flutter_test.dart';",
  ];
}
