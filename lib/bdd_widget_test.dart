import 'dart:io';
import 'package:bdd_widget_test/src/feature_file.dart';
import 'package:bdd_widget_test/src/regex.dart';
import 'package:build/build.dart';
import 'package:path/path.dart' as p;
import 'dart:async';
import 'dart:convert';

Builder featureBuilder(BuilderOptions options) => FeatureBuilder();

class FeatureBuilder implements Builder {
  @override
  Future build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final contents = await buildStep.readAsString(inputId);
    final feature = FeatureFile(path: inputId.path, package: inputId.package, input: contents);

    var featureDart = inputId.changeExtension('_test.dart');
    var testPath = p.join(p.dirname(p.dirname(featureDart.path)), 'tests', p.basename(featureDart.path));
    var featureDart1 = AssetId.deserialize([featureDart.package, testPath]);

    await buildStep.writeAsString(featureDart1, await feature.dartContent);
    var stepsFolderPath = p.join(p.dirname(p.dirname(feature.path)), 'steps');
    var functions = await findAllFunctions(stepsFolderPath);
    var newFunctions = <String>[];
    var newImports = <String>[];
    for (final step in feature.getStepFiles()) {
      if (!functions.contains(step.definition)) {
        newFunctions.add(step.content);
        newImports.addAll(step.imports);
      }
    }

    await createGeneralFile(stepsFolderPath, feature, newFunctions, newImports);

  }

  Future<List<String>> findAllFunctions(String directory) async {
    var stepList = Directory(directory).list(recursive: true, followLinks: false);
    var temp = <String>[];
    await for (var entity in stepList) {
      if (await FileSystemEntity.isFile(entity.path)) {
        var filename = entity.path;
        if (p.basename(filename) != 'general_steps.dart') {
          final file = await File(filename);
          final length = await file.length();
          if (length > 0) {
            await file.openRead().map(utf8.decode).transform(LineSplitter()).forEach((line) {
              var definition = functionDefinitionRegExp.stringMatch(line);
              if (definition != null) {
                temp.add(definition);
              }
            });
          }
        }
      }
    }
    return temp;
  }

  Future<void> createGeneralFile(String directory, FeatureFile feature, List<String> newFunctions, List<String> newImports) async {
    var filepath = p.join(directory, 'general_steps.dart');
    final file = await File(filepath).create(recursive: true);
    final length = await file.length();
    var imports = {...newImports};
    var paddedFunctions = <String>{...newFunctions};
    // 1 = comment func, 2 = start func, 0 = end func or not started
    var state = 0;
    var funcBody = '';
    if (length > 0) {
      await file.openRead().map(utf8.decode).transform(LineSplitter()).forEach((line) {
        var import = importRegExp.stringMatch(line);
        var funcComment = functionCommentRegExp.stringMatch(line);
        var funcSig = functionSignatureRegExp.stringMatch(line);
        var funcEnd = RegExp(r'}').stringMatch(line);

        if (import != null) {
          imports.add(import);
        } else if (funcComment != null && state == 0) {
          funcBody += '$line\n';
          state = 1;
        } else if (funcSig != null && [0, 1].contains(state)) {
          funcBody += '$line\n';
          state = 2;
        } else if (funcEnd == null && state == 2) {
          funcBody += '$line\n';
        } else if (funcEnd != null && state == 2) {
          funcBody += '$line\n';
          state = 0;
          paddedFunctions.add(funcBody);
          funcBody = '';
        }
      });
    }

    file.openWrite().writeAll([...imports, '\n', ...paddedFunctions], '\n');
  }

  @override
  final buildExtensions = const {
    '.feature': ['_test.dart']
  };
}
