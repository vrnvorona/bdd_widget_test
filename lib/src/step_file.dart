import 'package:bdd_widget_test/src/step_generator.dart';
import 'package:path/path.dart' as p;
import 'regex.dart';

class StepFile {
  StepFile(String featureDir, this.package, this.line)
      : filename = p.join(featureDir, 'steps', '${getStepFilename(line)}.dart'),
        import = p.join('.', 'steps', '${getStepFilename(line)}.dart').replaceAll('\\', '/');

  final String filename;
  final String import;
  final String package;
  final String line;

  String get definition => functionDefinitionRegExp.stringMatch(dartContent['content']);
  String get content => dartContent['content'];
  List<String> get imports => dartContent['imports'];
  Map<String, dynamic> get dartContent => generateStepDart(package, line);
}
