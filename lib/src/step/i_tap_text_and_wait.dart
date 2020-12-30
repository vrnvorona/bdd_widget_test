import 'package:bdd_widget_test/src/step/bdd_step.dart';

class ITapTextAndWait implements SurfBddStep {
  @override
  String get content => '''
Future<void> iTapTextAndWait(WidgetTester tester, String text) async {
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}
''';

  @override
  List<String> get imports => ["import 'package:flutter_test/flutter_test.dart';"];
}
