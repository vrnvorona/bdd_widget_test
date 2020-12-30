import 'package:bdd_widget_test/src/step/bdd_step.dart';

class TheAppInRunningStep implements SurfBddStep {
  const TheAppInRunningStep(this.package);
  final String package;

  @override
  String get content => '''
Future<void> theAppIsRunning(WidgetTester tester) async {
  app.main();
}
''';

  @override
  List<String> get imports => [
    "import 'package:flutter_test/flutter_test.dart';",
    "import 'package:$package/main.dart' as app;",
  ];
}
