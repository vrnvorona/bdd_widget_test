import 'package:bdd_widget_test/src/step/bdd_step.dart';

class ITapIcon implements SurfBddStep {
  @override
  String get content => '''
Future<void> iTapIcon(WidgetTester tester, IconData icon) async {
  await tester.tap(find.byIcon(icon));
  await tester.pump();
}
''';

  @override
  List<String> get imports => [
    "import 'package:flutter/widgets.dart';",
    "import 'package:flutter_test/flutter_test.dart';",
  ];
}
