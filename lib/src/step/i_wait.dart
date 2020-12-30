import 'package:bdd_widget_test/src/step/bdd_step.dart';

class IWait implements SurfBddStep {
  @override
  String get content => '''
Future<void> iWait(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
''';

  @override
  List<String> get imports => ["import 'package:flutter_test/flutter_test.dart';"];
}
