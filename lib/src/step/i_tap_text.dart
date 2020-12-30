import 'package:bdd_widget_test/src/step/bdd_step.dart';

class ITapText implements SurfBddStep {
  @override
  String get content => '''
Future<void> iTapText(WidgetTester tester, String text) async {
  await tester.tap(find.text(text));
  await tester.pump();
}
''';

  @override
  List<String> get imports => ["import 'package:flutter_test/flutter_test.dart';"];
}
