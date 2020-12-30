import 'package:bdd_widget_test/src/step/bdd_step.dart';

class DismissThePage implements SurfBddStep {
  @override
  String get content => '''
Future<void> dismissThePage(WidgetTester tester) async {
  await tester.pageBack();
  await tester.pumpAndSettle();
}
''';

  @override
  List<String> get imports => ["import 'package:flutter_test/flutter_test.dart';"];
}
